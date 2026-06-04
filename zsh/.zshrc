ZCONFDIR="$HOME/.config/zsh"
ZSH_LOCAL="$ZCONFDIR/local.zsh"

#---[ Loading Config Files ]-----------------------------------------
[[ ! -f "$ZSH_LOCAL" ]] && cp "$ZSH_LOCAL.example" "$ZSH_LOCAL"

local config_files=(
    "options.zsh"
    "functions.zsh"
    "plugins.zsh"
    "aliases.zsh"
    "binds.zsh"
    "fzf.zsh"
    "local.zsh"
)

for file in "${config_files[@]}"; do
    if [[ -f "$ZCONFDIR/$file" ]]; then
        if [[ "$file" == "binds.zsh" ]] && type zsh-defer >/dev/null 2>&1; then
            zsh-defer source "$ZCONFDIR/$file"
        else
            source "$ZCONFDIR/$file"
        fi
    fi
done


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

unset tool
