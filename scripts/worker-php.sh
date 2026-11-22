select_worker_php() {
    local candidate
    local -a candidates
    if [[ -n "${PHP_CLI_PATH:-}" ]]; then
        candidates=("$PHP_CLI_PATH")
    else
        candidates=(/opt/php/8.2/bin/php php /opt/php*/bin/php /opt/php/*/bin/php /opt/plesk/php/*/bin/php /opt/alt/php*/usr/bin/php /usr/bin/php8.*)
    fi
    for candidate in "${candidates[@]}"; do
        command -v -- "$candidate" >/dev/null 2>&1 || continue
        if "$candidate" bin/preflight.php --php-only >/dev/null 2>&1; then
            worker_php=("$candidate")
            return 0
        fi
        if "$candidate" -d extension=sodium bin/preflight.php --php-only >/dev/null 2>&1; then
            worker_php=("$candidate" -d extension=sodium)
            return 0
        fi
    done
    echo "Не найден PHP CLI 8.2+ с нужными расширениями, включая sodium. Укажите путь через PHP_CLI_PATH." >&2
    return 1
}
