ZCONFDIR="$HOME/.config/zsh"
ZSH_LOCAL="$ZCONFDIR/local.zsh"

# Disable System Compinit
compinit() {}

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
local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
local tool tools=(starship zoxide)

for tool in "${tools[@]}"; do
    if (( ${+commands[$tool]} )); then
        local cache_file="$cache_dir/${tool}-init.zsh"
        
        if [[ ! -f "$cache_file" || "$commands[$tool]" -nt "$cache_file" ]]; then
            "$tool" init zsh >| "$cache_file"
            zcompile "$cache_file" &!
        fi
        source "$cache_file"
    fi
done
