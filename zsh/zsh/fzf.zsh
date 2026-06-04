#---[ Customization ]------------------------------------------------
typeset -g Z_FZF_WINDOW_OPTS="--ansi --height 45% --layout=reverse --border=rounded --inline-info"

typeset -g Z_FZF_COLOR_OPTS="--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

typeset -g Z_FZF_DEFAULT_OPTS="$Z_FZF_WINDOW_OPTS $Z_FZF_COLOR_OPTS"


#---[ Tools Selection ]--------------------------------------------------------
# Search
if (( $+commands[fd] )); then
    typeset -g Z_FZF_CMD_FILE="fd --type f --hidden --exclude .git --color=always"
    typeset -g Z_FZF_CMD_DIR="fd --type d --hidden --exclude .git --color=always"
else
    typeset -g Z_FZF_CMD_FILE="find . -type f -path '*/\.git/*' -prune -o -print"
    typeset -g Z_FZF_CMD_DIR="find . -type d -path '*/\.git/*' -prune -o -print"
fi

# File Preview
if (( $+commands[bat] )); then
    typeset -g Z_FZF_PREVIEW_FILE="bat --color=always --style=numbers --line-range=:500 {}"
else
    typeset -g Z_FZF_PREVIEW_FILE="cat {}"
fi

# Directory Preview
if (( $+commands[eza] )); then
    typeset -g Z_FZF_PREVIEW_DIR="eza --tree --level=2 --color=always {}"
elif (( $+commands[tree] )); then
    typeset -g Z_FZF_PREVIEW_DIR="tree -C {}"
else
    typeset -g Z_FZF_PREVIEW_DIR="ls -la {}"
fi


#---[ History Search [Ctrl+R] ]--------------------------------------
fzf-history-widget() {
    local selected
    selected=$(fc -rl 1 | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+[*[:space:]]*//' | \
               awk '!seen[$0]++' | \
               fzf --prompt="History >  " --query="$LBUFFER" ${(z)Z_FZF_DEFAULT_OPTS})
    if [[ -n "$selected" ]]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle reset-prompt
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget


#---[ File Search [Ctrl+F] ]-----------------------------------------
fzf-file-widget() {
    local selected
    selected=$(eval "$Z_FZF_CMD_FILE" | \
               fzf --prompt="Files >  " --preview="$Z_FZF_PREVIEW_FILE" ${(z)Z_FZF_DEFAULT_OPTS})
    if [[ -n "$selected" ]]; then
        LBUFFER+="${(q)selected} "
    fi
    zle reset-prompt
}
zle -N fzf-file-widget
bindkey '^F' fzf-file-widget


#---[ Interactive CD [Alt+C] ]---------------------------------------
fzf-dir-widget() {
    local selected
    selected=$(eval "$Z_FZF_CMD_DIR" | \
               fzf --prompt="Dir >  " --preview="$Z_FZF_PREVIEW_DIR" ${(z)Z_FZF_DEFAULT_OPTS})
    if [[ -n "$selected" ]]; then
        cd "$selected" || return
    fi
    zle reset-prompt
}
zle -N fzf-dir-widget
bindkey '\ec' fzf-dir-widget
