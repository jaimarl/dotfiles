#---[ Antidote ]-----------------------------------------------------
ANTIDOTE_DIR="${ZDOTDIR:-$HOME}/.antidote"

if [[ ! -d "$ANTIDOTE_DIR" ]]; then
    echo "Installing Antidote..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

source "$ANTIDOTE_DIR/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt


#---[ Starship ]-----------------------------------------------------
(( ${+commands[starship]} )) && eval "$(starship init zsh)"


#---[ Preferences ]--------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

autoload -U select-word-style
select-word-style bash


#---[ Aliases ]------------------------------------------------------
# Replacements
calias() { if (( ${+commands[${2%% *}]} )); then alias $1=$2; fi }
calias cat "bat"
calias ls "eza -a --icons=always"

# Neovim
alias n="nvim"
alias sn="sudo -Es nvim"

# Abbreviations
alias ff="clear && fastfetch"
alias ..="cd .."
alias -g G="| grep"

# Other
alias zrephist="strings ~/.zsh_history > ~/.zsh_history"


#---[ Binds ]--------------------------------------------------------
bindkey "^[[1;5D" backward-word
bindkey "^H" backward-kill-word
bindkey "^[[1;5C" forward-word
bindkey '^[[3;5~' kill-word

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down


#---[ Plugin Configuration ]-----------------------------------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

function magic-enter-cmd {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "ls; echo ''; git status -s"
    else
        echo "ls"
    fi
}


#---[ Functions ]----------------------------------------------------
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


#---[ Yazi ]---------------------------------------------------------
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
