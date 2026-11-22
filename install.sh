#!/usr/bin/env bash
set -euo pipefail
umask 077
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
case "${1:-}" in
    ''|--cron) ;;
    *) echo 'Использование: bash install.sh [--cron]' >&2; exit 2 ;;
esac
command -v flock >/dev/null || { echo 'Нужен flock.' >&2; exit 1; }
mkdir -p -- storage/logs
exec 8>storage/install.lock
flock -n 8 || { echo 'Установка уже выполняется.' >&2; exit 1; }

bash setup-worker.sh
bash grant-worker-permissions.sh
bash start-worker.sh --status
cron_line="*/5 * * * * bash '$PWD/start-worker.sh' --once >> '$PWD/storage/logs/worker-cron.log' 2>&1"
if [[ "${1:-}" != --cron ]]; then
    printf 'Команда для периодического задания:\n%s\n' "$cron_line"
    exit 0
fi
if [[ ! "$PWD" =~ ^/[a-zA-Z0-9_./-]+$ ]] || ! command -v crontab >/dev/null; then
    printf 'Добавьте задание в панели хостинга:\n%s\n' "$cron_line" >&2
    exit 1
fi
existing=$(mktemp)
errors=$(mktemp)
trap 'rm -f -- "$existing" "$errors"' EXIT
if ! LC_ALL=C crontab -l >"$existing" 2>"$errors" && ! grep -q '^no crontab for ' "$errors"; then
    printf 'SSH не позволяет прочитать задания. Проверьте панель хостинга и добавьте при необходимости:\n%s\n' "$cron_line" >&2
    exit 1
fi
if grep -Fxq -- "$cron_line" "$existing"; then
    echo 'Задание cron уже зарегистрировано.'
elif grep -Eq 'studpulse[^[:space:]]*(bin/cron\.php|start-worker\.sh)' "$existing"; then
    echo 'Найдено прежнее задание StudPulse. Проверьте его перед заменой.' >&2
    printf '%s\n' "$cron_line"
    exit 1
else
    printf '\n%s\n' "$cron_line" >> "$existing"
    if ! crontab "$existing" || ! crontab -l | grep -Fx -- "$cron_line" >/dev/null; then
        printf 'Регистрация через SSH не подтверждена. Проверьте панель хостинга:\n%s\n' "$cron_line" >&2
        exit 1
    fi
    echo 'Задание cron зарегистрировано. Первый проход подтвердите в storage/logs/worker-cron.log.'
fi
