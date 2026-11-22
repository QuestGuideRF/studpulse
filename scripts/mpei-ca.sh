prepare_mail_ca() (
    local source_pem=$1 target_pem=$2 mail_python=$3 candidate temp download python_temp=
    local official='https://mpei.ru/Structure/uchchast/icc/Documents/certnew.p7b'
    case "$source_pem" in '~/'*) source_pem="$HOME/${source_pem:2}" ;; esac
    case "$target_pem" in "$PWD/public/"*) echo 'Почта МЭИ: PEM должен быть вне public.' >&2; return 1 ;; esac
    mkdir -p -- "$(dirname -- "$target_pem")" || return 1
    local private_dir public_dir
    private_dir=$(realpath -- "$(dirname -- "$target_pem")") || return 1
    public_dir=$(realpath -- public) || return 1
    case "$private_dir/" in "$public_dir/"*) echo 'Почта МЭИ: PEM должен быть вне public.' >&2; return 1 ;; esac
    temp=$(mktemp -- "$private_dir/.mpei-ca.XXXXXX") || return 1
    download=
    trap 'rm -f -- "$temp"; [[ -z "$download" ]] || rm -f -- "$download"; [[ -z "$python_temp" ]] || rm -f -- "$python_temp"' EXIT
    local -a candidates=("$target_pem" "$source_pem")
    if [[ -n "${HOME:-}" ]]; then candidates+=("$HOME/mpei-ca-chain.pem" "$HOME/mpei-ca.p7b"); fi
    for candidate in "${candidates[@]}"; do
        [[ -n "$candidate" && -f "$candidate" && -r "$candidate" ]] || continue
        candidate=$(realpath -- "$candidate") || continue
        if "${worker_php[@]}" bin/mpei-ca.php < "$candidate" > "$temp"; then
            break
        fi
        printf 'Почта МЭИ: %s не прошёл проверку цепочки.\n' "$candidate" >&2
        : > "$temp"
    done
    if [[ ! -s "$temp" ]] && command -v curl >/dev/null 2>&1; then
        download=$(mktemp -- "$private_dir/.mpei-p7b.XXXXXX") || return 1
        if ! curl --fail --silent --show-error --proto '=https' --connect-timeout 8 --max-time 20 --max-filesize 262144 --output "$download" "$official" ||
            ! "${worker_php[@]}" bin/mpei-ca.php < "$download" > "$temp"; then
            : > "$temp"
        fi
    fi
    if [[ ! -s "$temp" ]]; then
        echo 'Почта МЭИ: подтверждённая цепочка недоступна. Проверьте MPEI_MAIL_CA_FILE, HOME или доступ к официальному certnew.p7b.' >&2
        return 1
    fi
    mail_python=$(command -v -- "$mail_python") || { echo 'Почта МЭИ: Python не найден.' >&2; return 1; }
    mail_python=$(realpath -- "$mail_python") || return 1
    if ! "$mail_python" scripts/mpei-mail.py --check "$temp"; then
        echo 'Почта МЭИ: Python не смог загрузить подтверждённый PEM. Проверьте MPEI_MAIL_PYTHON.' >&2
        return 1
    fi
    printf 'Почта МЭИ: Python %s\n' "$mail_python"
    "$mail_python" --version
    chmod 600 -- "$temp" && mv -f -- "$temp" "$target_pem" || return 1
    python_temp=$(mktemp -- "$private_dir/.python-path.XXXXXX") || return 1
    printf '%s\n' "$mail_python" > "$python_temp" && mv -f -- "$python_temp" "$private_dir/python-path" || return 1
    echo 'Почта МЭИ: PEM проверен и сохранён в закрытом хранилище.'
    "$mail_python" scripts/mpei-mail.py --probe "$target_pem"
)
