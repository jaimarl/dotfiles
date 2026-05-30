#---[ Binds ]--------------------------------------------------------
bindkey "^[[1;5D" backward-word
bindkey "^H" backward-kill-word
bindkey "^[[1;5C" forward-word
bindkey '^[[3;5~' kill-word

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

sudo-command-line() {
    [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
    CURSOR=$#BUFFER
}
zle -N sudo-command-line
bindkey '\e\e' sudo-command-line
