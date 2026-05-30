#---[ Functions ]----------------------------------------------------
function mkcd() { mkdir -p "$1" && cd "$1"; }

function up() {
    local d=""
    local limit="$1"

    if [[ ! "$limit" =~ ^[0-9]+$ ]]; then
        limit=1
    fi

    for ((i=1; i <= limit; i++)); do
        d="../$d"
    done

    cd "$d"
}

function extract() {
    if [ -f "$1" ]; then
        local dest="${2:-.}"
        
        if [[ ! -d "$dest" ]]; then
            mkdir -p "$dest"
        fi

        case "$1" in
            *.tar.bz2)   tar xjf "$1" -C "$dest"    ;;
            *.tar.gz)    tar xzf "$1" -C "$dest"    ;;
            *.tar.xz)    tar xf "$1" -C "$dest"     ;;
            *.bz2)       bunzip2 "$1"               ;;
            *.rar)       unrar x "$1" "$dest"       ;;
            *.gz)        gunzip "$1"                ;;
            *.tar)       tar xf "$1" -C "$dest"     ;;
            *.tbz2)      tar xjf "$1" -C "$dest"    ;;
            *.tgz)       tar xzf "$1" -C "$dest"    ;;
            *.txz)       tar xf "$1" -C "$dest"     ;;
            *.zip)       unzip "$1" -d "$dest"      ;;
            *.Z)         uncompress "$1"            ;;
            *.7z)        7z x "$1" -o"$dest"        ;;
            *)           echo "Error: Unknown file type" ;;
        esac
    else
        echo "Error: '$1' is not a file"
    fi
}

if (( $+commands[yazi] )); then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi

