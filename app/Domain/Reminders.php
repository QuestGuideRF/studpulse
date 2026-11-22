<?php declare(strict_types=1);namespace StudPulse\Domain;use StudPulse\Database\DB;final class Reminders{public static function collect(?string$user=null):int{$deadlines=DB::run("INSERT IGNORE INTO notifications(id,recipient_user_id,type,title,body,related_type,related_id,dedupe_key)
            SELECT UUID(),candidate.user_id,'deadline','Приближается срок задания','Проверьте свои задания в StudPulse.',
                'homework',candidate.id,CONCAT('deadline:',candidate.id,':',candidate.revision,':',candidate.user_id)
            FROM (
                SELECT h.id,h.revision,h.author_user_id AS user_id,h.due_at FROM homework h
                WHERE h.group_id IS NULL AND h.term_id IS NULL AND h.deleted_at IS NULL
                AND h.due_at>UTC_TIMESTAMP(6) AND h.due_at<=DATE_ADD(UTC_TIMESTAMP(6),INTERVAL 1 DAY)
                UNION
                SELECT h.id,h.revision,gm.user_id,h.due_at FROM homework h
                JOIN group_memberships gm ON gm.group_id=h.group_id AND gm.term_id=h.term_id
                    AND gm.valid_from<=UTC_TIMESTAMP(6) AND gm.valid_to>UTC_TIMESTAMP(6)
                WHERE h.deleted_at IS NULL AND h.due_at>UTC_TIMESTAMP(6) AND h.due_at<=DATE_ADD(UTC_TIMESTAMP(6),INTERVAL 1 DAY)
            ) candidate JOIN users u ON u.id=candidate.user_id AND u.status='active'
            LEFT JOIN user_preferences p ON p.user_id=u.id
            LEFT JOIN homework_completions c ON c.homework_id=candidate.id AND c.user_id=u.id
            WHERE (? IS NULL OR u.id=?) AND c.user_id IS NULL AND COALESCE(p.preferences->>'$.notifications.reminders','true')='true'
            AND NOT EXISTS(SELECT 1 FROM notifications n WHERE n.recipient_user_id=u.id
                AND n.dedupe_key=CONCAT('deadline:',candidate.id,':',candidate.revision,':',u.id))
            ORDER BY candidate.due_at,candidate.id,u.id LIMIT 500",[$user,$user])->rowCount();$journal=DB::run("INSERT IGNORE INTO notifications(id,recipient_user_id,type,title,body,related_type,related_id,dedupe_key)
            SELECT UUID(),u.id,'journal','Заполните журнал',
                CONCAT(DATE_FORMAT(CONVERT_TZ(d.payload_json->>'$.start_at','+00:00','+03:00'),'%d.%m'),' · ',LEFT(COALESCE(d.payload_json->>'$.subject_title','Занятие'),180)),
                'journal',d.id,CONCAT('journal:',d.id)
            FROM headman_class_drafts d JOIN terms t ON t.id=d.term_id AND t.archived_at IS NULL AND UTC_DATE() BETWEEN t.begins_at AND t.ends_at
            JOIN group_memberships gm ON gm.group_id=d.group_id AND gm.term_id=d.term_id
                AND gm.role IN ('headman','deputy') AND gm.valid_from<=UTC_TIMESTAMP(6) AND gm.valid_to>UTC_TIMESTAMP(6)
            JOIN users u ON u.id=gm.user_id AND u.status='active' LEFT JOIN user_preferences p ON p.user_id=u.id
            WHERE (? IS NULL OR u.id=?) AND d.state='local_draft'
            AND d.payload_json->>'$.end_at' BETWEEN DATE_SUB(UTC_TIMESTAMP(6),INTERVAL 14 DAY) AND DATE_SUB(UTC_TIMESTAMP(6),INTERVAL 15 MINUTE)
            AND NOT EXISTS(SELECT 1 FROM headman_attendance_drafts ad WHERE ad.class_draft_id=d.id AND ad.status IN ('recorded','submitted'))
            AND NOT EXISTS(SELECT 1 FROM notifications n WHERE n.recipient_user_id=u.id AND n.dedupe_key=CONCAT('journal:',d.id))
            AND COALESCE(p.preferences->>'$.notifications.reminders','true')='true'
            ORDER BY d.id,u.id LIMIT 500",[$user,$user])->rowCount();return$deadlines+$journal;}}