#!/usr/bin/env bash
set -euo pipefail
umask 077
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
for command in flock timeout; do
    if ! command -v -- "$command" >/dev/null 2>&1; then
        printf 'Не найдена команда %s. Проверьте PHP_CLI_PATH, util-linux (flock) и GNU coreutils (timeout) на хостинге.\n' "$command" >&2
        exit 1
    fi
done
echo "Проверяю PHP и расширения…"
source scripts/worker-php.sh
select_worker_php
printf 'Выбран PHP CLI: %s\n' "$(command -v -- "${worker_php[0]}")"
composer_args=(install --no-dev --no-interaction --prefer-dist --no-scripts --no-plugins)
if [[ -n "${COMPOSER_PHAR:-}" ]]; then
    "${worker_php[@]}" "$COMPOSER_PHAR" "${composer_args[@]}"
elif command -v composer >/dev/null 2>&1; then
    composer_bin=$(command -v composer)
    if head -n 1 "$composer_bin" | grep -Eq '^#!.*php|^<\?php'; then
        "${worker_php[@]}" "$composer_bin" "${composer_args[@]}"
    else
        echo "Для запуска Composer с выбранным PHP укажите путь к composer.phar через COMPOSER_PHAR."
    fi
else
    echo "Рабочие зависимости StudPulse входят в PHP. Composer можно указать через COMPOSER_PHAR."
fi
mkdir -p -- storage/{files,logs,mail,notifications}
if [[ ! -f .env ]]; then
    "${worker_php[@]}" bin/setup.php
    echo "Заполните .env параметрами хостинга (MySQL, HTTPS и почта), затем повторите настройку."
    exit 1
fi
echo "Проверяю конфигурацию, MySQL и закрытое хранилище…"
"${worker_php[@]}" bin/migrate.php
mail_paths=$("${worker_php[@]}" bin/preflight.php --mail-install-paths)
mail_failed=0
if [[ -n "$mail_paths" ]]; then
    mapfile -t paths <<< "$mail_paths"
    source scripts/mpei-ca.sh
    if ! prepare_mail_ca "${paths[@]}"; then
        mail_failed=1
        echo 'Почта МЭИ: подготовка или сетевой тест завершились с ошибкой.' >&2
    fi
fi
"${worker_php[@]}" bin/preflight.php
if (( mail_failed )); then exit 1; fi
echo "Готово. Выдайте права командой bash grant-worker-permissions.sh."
