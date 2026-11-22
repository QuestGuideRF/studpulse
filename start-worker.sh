#!/usr/bin/env bash
set -u
umask 077
cd -- "$(dirname -- "${BASH_SOURCE[0]}")" || exit 1
state="$PWD/storage/notifications"
script="$PWD/start-worker.sh"
mkdir -p -- "$state" || exit 1
command -v flock >/dev/null 2>&1 || { echo "Для запуска нужен flock (util-linux)." >&2; exit 1; }
exec 9>"$state/worker.lock" || exit 1
case "${1:-}" in
    --status)
        if flock -n 9; then
            echo "Планировщик в режиме цикла остановлен. Короткие задачи cron запускаются отдельно."
        elif read -r pid started < "$state/worker.pid" && [[ "$pid" =~ ^[1-9][0-9]*$ ]] &&
            [[ "$(awk '{print $22}' "/proc/$pid/stat" 2>/dev/null)" == "$started" ]] &&
            grep -Fzxq -- "$script" "/proc/$pid/cmdline"; then
            printf 'Планировщик в режиме цикла работает (PID %s).\n' "$pid"
        else
            echo "Планировщик занят короткой задачей или запускается."
        fi
        ;;
    --once)
        if ! flock -n 9; then
            echo "Планировщик уже занят. Этот проход пропущен."
            exit 0
        fi
        source scripts/worker-php.sh || exit 1
        select_worker_php || exit 1
        timeout --kill-after=5s 90s "${worker_php[@]}" bin/cron.php --worker
        result=$?
        if (( result == 75 )); then exit 0; fi
        exit "$result"
        ;;
    --stop)
        if flock -n 9; then
            echo "Планировщик уже остановлен."
            exit 0
        fi
        if ! read -r pid started < "$state/worker.pid" || [[ ! "$pid" =~ ^[1-9][0-9]*$ ]]; then
            echo "Не удалось определить PID планировщика. Повторите через несколько секунд." >&2
            exit 1
        fi
        actual=$(awk '{print $22}' "/proc/$pid/stat" 2>/dev/null) || exit 1
        if [[ "$actual" != "$started" ]] || ! grep -Fzxq -- "$script" "/proc/$pid/cmdline"; then
            echo "PID уже принадлежит другому процессу. Остановка отменена." >&2
            exit 1
        fi
        kill -TERM "$pid" || exit 1
        if flock -w 105 9; then
            echo "Планировщик остановлен."
        else
            echo "Планировщик ещё завершает текущую проверку." >&2
            exit 1
        fi
        ;;
    --run)
        if ! flock -n 9; then
            echo "Планировщик StudPulse уже запущен." >&2
            exit 1
        fi
        interval=${STUDPULSE_NOTIFY_INTERVAL:-60}
        source scripts/worker-php.sh || exit 1
        select_worker_php || exit 1
        if ! command -v timeout >/dev/null 2>&1; then
            echo "Для запуска нужен timeout (GNU coreutils)." >&2
            exit 1
        fi
        if [[ ! "$interval" =~ ^[1-9][0-9]{1,4}$ ]] || (( interval < 30 )); then
            echo "STUDPULSE_NOTIFY_INTERVAL должен быть числом от 30 до 99999 секунд." >&2
            exit 1
        fi
        started=$(awk '{print $22}' "/proc/$$/stat") || exit 1
        printf '%s %s\n' "$$" "$started" > "$state/worker.pid" || exit 1
        stopping=0
        sleeper=
        trap 'stopping=1; if [[ -n "$sleeper" ]]; then kill "$sleeper" 2>/dev/null || true; fi' TERM INT
        trap 'rm -f -- "$state/worker.pid"' EXIT
        echo "Планировщик StudPulse запущен (PID $$, интервал $interval с). PHP: $(command -v -- "${worker_php[0]}")."
        "${worker_php[@]}" bin/preflight.php --mail-runtime
        while (( ! stopping )); do
            echo "Проверяю уведомления и задачи библиотеки…"
            timeout --kill-after=5s 90s "${worker_php[@]}" bin/cron.php --worker
            result=$?
            delay=$interval
            case "$result" in
                0) echo "Проверка завершена." ;;
                75) delay=5; echo "Позиция обхода сохранена." ;;
                124|137) echo "Проверка прервана по тайм-ауту. Следующая попытка — через $interval с." >&2 ;;
                *) echo "Проверка завершилась с ошибкой (код $result). Подробности выше." >&2 ;;
            esac
            (( stopping )) && break
            echo "Следующая проверка через $delay с."
            sleep "$delay" &
            sleeper=$!
            (( stopping )) && kill "$sleeper" 2>/dev/null
            wait "$sleeper" 2>/dev/null || true
            sleeper=
        done
        echo "Планировщик завершил работу."
        ;;
    "")
        exec bash "$script" --run
        ;;
    *)
        echo "Использование: bash start-worker.sh [--once|--status|--stop]" >&2
        exit 1
        ;;
esac
