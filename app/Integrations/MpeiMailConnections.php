<?php
declare(strict_types=1);
namespace StudPulse\Integrations;

use StudPulse\Config;
use StudPulse\Database\DB;
use StudPulse\Http\ApiError;
use StudPulse\Security\Crypto;

final class MpeiMailConnections
{
    public static function find(string $session): ?array
    {
        return DB::one('SELECT * FROM mpei_mail_connections WHERE session_id=? AND expires_at>UTC_TIMESTAMP(6)', [$session]);
    }

    public static function store(array $session, string $login, #[\SensitiveParameter] string $password, bool $poll, ?object $inbox): void
    {
        $ciphertext = Crypto::encrypt(json_encode(['purpose' => 'mpei-mail', 'session' => $session['id'], 'login' => $login, 'password' => $password], JSON_THROW_ON_ERROR));
        DB::run('INSERT INTO mpei_mail_connections
            (session_id,generation,ciphertext,expires_at,poll_enabled,uid_validity,uid_next,next_check_at)
            VALUES(?,?,?,LEAST(?,DATE_ADD(UTC_TIMESTAMP(6),INTERVAL 30 DAY)),?,?,?,DATE_ADD(UTC_TIMESTAMP(6),INTERVAL 5 MINUTE)) AS incoming
            ON DUPLICATE KEY UPDATE generation=incoming.generation,ciphertext=incoming.ciphertext,expires_at=incoming.expires_at,
              poll_enabled=incoming.poll_enabled,uid_validity=incoming.uid_validity,uid_next=incoming.uid_next,next_check_at=incoming.next_check_at',
            [$session['id'], DB::id(), $ciphertext, $session['expires_at'], (int)$poll, (int)($inbox->uidvalidity ?? 0), (int)($inbox->uidnext ?? 0)]);
    }

    public static function credentials(array $connection): array
    {
        $data = json_decode(Crypto::decrypt($connection['ciphertext']), true, 8, JSON_THROW_ON_ERROR);
        if (($data['purpose'] ?? '') !== 'mpei-mail' || ($data['session'] ?? '') !== $connection['session_id']) {
            throw new \RuntimeException('Invalid mailbox connection');
        }
        return [$data['login'], $data['password']];
    }

    public static function remove(string $session, ?string $generation = null): void
    {
        DB::run('DELETE FROM mpei_mail_connections WHERE session_id=? AND (? IS NULL OR generation=?)', [$session, $generation, $generation]);
    }

    public static function removeAccount(string $user): void
    {
        DB::run('DELETE c FROM mpei_mail_connections c JOIN user_sessions s ON s.id=c.session_id WHERE s.user_id=?', [$user]);
    }

    public static function mailboxKey(string $login): string
    {
        return Crypto::hash('mpei-mail:' . strtolower($login));
    }

    public static function poll(): int
    {
        if (!Config::bool('MPEI_MAIL_ENABLED')) return 0;
        $idle = (int)Config::get('SESSION_IDLE_DAYS', '7');
        $active = "s.revoked_at IS NULL AND s.expires_at>UTC_TIMESTAMP(6)
            AND s.last_seen_at>DATE_SUB(UTC_TIMESTAMP(6),INTERVAL $idle DAY) AND u.status='active'";
        DB::run("DELETE c FROM mpei_mail_connections c JOIN user_sessions s ON s.id=c.session_id
            JOIN users u ON u.id=s.user_id WHERE c.expires_at<=UTC_TIMESTAMP(6) OR NOT ($active)");
        if (!MpeiMailbox::available()) return 0;
        $rows = DB::all("SELECT c.*,s.user_id FROM mpei_mail_connections c JOIN user_sessions s ON s.id=c.session_id
            JOIN users u ON u.id=s.user_id WHERE $active AND c.poll_enabled=1 AND c.expires_at>UTC_TIMESTAMP(6)
            AND c.next_check_at<=UTC_TIMESTAMP(6) ORDER BY c.next_check_at LIMIT 10");
        $deadline = microtime(true) + 10;
        $count = 0;
        foreach ($rows as $row) {
            if (microtime(true) >= $deadline) break;
            $reserved = DB::run('UPDATE mpei_mail_connections SET next_check_at=DATE_ADD(UTC_TIMESTAMP(6),INTERVAL 1 MINUTE)
                WHERE session_id=? AND generation=? AND next_check_at<=UTC_TIMESTAMP(6)', [$row['session_id'], $row['generation']]);
            if (!$reserved->rowCount()) continue;
            try {
                [$login, $password] = self::credentials($row);
                $result = MpeiMailbox::read('poll', $login, $password,
                    ['validity' => (int)$row['uid_validity'], 'nextUid' => (int)$row['uid_next']]);
            } catch (ApiError $error) {
                if ($error->errorCode === 'MPEI_MAIL_AUTH') self::remove($row['session_id'], $row['generation']);
                else error_log('StudPulse MPEI mail: ' . $error->errorCode);
                continue;
            } catch (\Throwable $error) {
                error_log('StudPulse MPEI mail: ' . get_class($error));
                continue;
            }

            $count += DB::transaction(function () use ($row, $result, $active, $login): int {
                $interval = $result['more'] ? 1 : 5;
                $updated = DB::run("UPDATE mpei_mail_connections c JOIN user_sessions s ON s.id=c.session_id
                    JOIN users u ON u.id=s.user_id
                    SET c.uid_validity=?,c.uid_next=?,c.last_synced_at=UTC_TIMESTAMP(6),
                        c.next_check_at=DATE_ADD(UTC_TIMESTAMP(6),INTERVAL $interval MINUTE)
                    WHERE $active AND c.expires_at>UTC_TIMESTAMP(6) AND c.session_id=? AND c.generation=?
                    AND c.uid_validity=? AND c.uid_next=?",
                    [$result['uidValidity'], $result['uidNext'], $row['session_id'], $row['generation'], $row['uid_validity'], $row['uid_next']]);
                if (!$updated->rowCount()) return 0;
                $inserted = 0;
                $mailbox = self::mailboxKey($login);
                if (isset($result['unread'])) {
                    MpeiMailCache::observeUnread($row, [$row['user_id'], $mailbox, 'inbox'], (int)$result['uidValidity'], (int)$result['unread']);
                }
                foreach (['inbox','sent','trash'] as $folder) {
                    $scope = [$row['user_id'], $mailbox, $folder];
                    if ($folder === 'inbox' && ($result['items'] || (int)$row['uid_validity'] !== (int)$result['uidValidity'])) {
                        MpeiMailCache::enqueue($scope, true);
                    } elseif (!MpeiMailCache::state($scope)) {
                        MpeiMailCache::enqueue($scope);
                    }
                }
                foreach ($result['items'] as $mail) {
                    $received = isset($mail['date']) ? strtotime($mail['date']) : false;
                    $key = "mpei-mail:$mailbox:{$result['uidValidity']}:{$mail['uid']}";
                    $inserted += DB::run("INSERT IGNORE INTO notifications
                        (id,recipient_user_id,type,title,body,related_type,dedupe_key,received_at)
                        VALUES(?,?,'mpei_mail',?,?,'mpei_mail',?,?)",
                        [DB::id(),$row['user_id'],$mail['subject'],$mail['from'] ?: 'Отправитель не указан',
                            $key,$received === false ? null : gmdate('Y-m-d H:i:s', $received)])->rowCount();
                }
                return $inserted;
            });
        }
        return $count;
    }
}
