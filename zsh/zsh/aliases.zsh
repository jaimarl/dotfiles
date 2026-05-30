calias() {
    if [[ $# -lt 2 ]]; then
        return 1
    fi

    local alias_name="$1"
    local alias_command="$2"
    local check_cmd="${3:-${2%% *}}"

    if command -v "$check_cmd" >/dev/null 2>&1; then
        alias "$alias_name"="$alias_command"
    fi
}

#---[ Aliases ]------------------------------------------------------
# Replacements
calias "cat" "bat"
calias "ls" "eza -a --icons=always"
alias ll="ls -lAh"

# Abbreviations
calias "n" "nvim"
calias "sn" "sudo -Es nvim" "nvim"
calias "ff" "clear && fastfetch" "fastfetch"
alias ..="cd .."
alias -g G="| grep"

# Zsh
alias zreload="source ~/.zshrc"
alias zrephist="strings $HISTFILE > $HISTFILE"
