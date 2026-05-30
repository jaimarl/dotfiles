ZCONFDIR="$HOME/.config/zsh"
ZSH_LOCAL="$ZCONFDIR/local.zsh"

#---[ Loading Config Files ]-----------------------------------------
if [ -d "$ZCONFDIR" ]; then
    for config_file in "$ZCONFDIR"/*.zsh(-.); do
        [[ "$(basename "$config_file")" == "local.zsh" ]] && continue

        source "$config_file"
    done
    unset config_file
fi

if [ ! -f "$ZSH_LOCAL" ]; then
    cp "$ZCONFDIR/local.zsh.example" "$ZCONFDIR/local.zsh"
fi
source "$ZSH_LOCAL"


#---[ Tools ]--------------------------------------------------------
(( ${+commands[starship]} )) && eval "$(starship init zsh)"
(( ${+commands[zoxide]} )) && eval "$(zoxide init zsh)"
