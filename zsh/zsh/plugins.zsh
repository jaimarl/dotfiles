#---[ Installing Plugins ]-------------------------------------------
plugins=(
    "romkatv/zsh-defer"
)

deferred_plugins=(
    "zshzoo/magic-enter"
    "hlissner/zsh-autopair"
    "zsh-users/zsh-history-substring-search"
    "zsh-users/zsh-completions"
    "zsh-users/zsh-autosuggestions"
    "Aloxaf/fzf-tab"
    "zdharma-continuum/fast-syntax-highlighting"
)


#---[ Plugin Configuration ]-----------------------------------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline,fg=magenta'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='underline,fg=red'

function magic-enter-cmd {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo " ls; echo ''; git status -s"
    else
        echo " ls"
    fi
}

local target="{}"
local fzf_opts=( ${(z)Z_FZF_WINDOW_OPTS} ${(z)Z_FZF_COLOR_OPTS} )
local dynamic_file_preview="${Z_FZF_PREVIEW_FILE//$target/\$file}"
local dynamic_dir_preview="${Z_FZF_PREVIEW_DIR//$target/\$word}"

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':fzf-tab:*' fzf-flags "${fzf_opts[@]}" --prompt="Cmd >  "

zstyle ':fzf-tab:complete:(cd|z):*' fzf-flags "${fzf_opts[@]}" --prompt="Dir >  "
zstyle ':fzf-tab:complete:(cd|z):*' fzf-preview ${(Q)dynamic_dir_preview}


#---[ Plugin Loader ]------------------------------------------------
ZPLUGINDIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/plugins"

_zplugin_load() {
    local repo_full="$1"
    local name="${repo_full#*/}"
    local plugin_path="${ZPLUGINDIR}/${name}"

    if [[ ! -d "$plugin_path" ]]; then
        mkdir -p "$ZPLUGINDIR"
        echo "📦 Installing ${name}..."
        git clone --depth=1 --quiet "https://github.com/${repo_full}" "$plugin_path" \
            || { echo "❌ ERROR: failed to install ${name}" >&2; return 1; }
    fi

    if [[ -d "${plugin_path}/src" ]]; then
        fpath=("${plugin_path}/src" $fpath)
    else
        fpath=("${plugin_path}" $fpath)
    fi

    if [[ -f "${plugin_path}/${name}.plugin.zsh" ]]; then
        source "${plugin_path}/${name}.plugin.zsh"
    elif [[ -f "${plugin_path}/${name}.zsh" ]]; then
        source "${plugin_path}/${name}.zsh"
    else
        local fallback
        fallback=("${plugin_path}"/*.plugin.zsh(N) "${plugin_path}"/*.zsh(N))
        if (( ${#fallback} > 0 )); then
            source "${fallback[1]}"
        else
            echo "⚠️ WARNING: Could not find entry point for ${name}" >&2
        fi
    fi

    unset plugin
}

_zplugin_cleanup() {
    [[ -d "$ZPLUGINDIR" ]] || return 0

    local active_plugins=()
    local p dir dname

    for p in "${plugins[@]}"; do
        active_plugins+=("${p#*/}")
    done

    for dir in "${ZPLUGINDIR}"/*(N-/); do
        dname="${dir:t}"
        
        if [[ ${active_plugins[(Ie)$dname]} -eq 0 ]]; then
            echo "🗑️ Deleting $dname..."
            rm -rf "$dir"
        fi
    done
}

zplugin-update() {
    local dir

    _zplugin_cleanup

    if [[ ! -d "$ZPLUGINDIR" ]]; then
        echo "⚠️ No plugins installed"
        return 0
    fi

    for dir in "${ZPLUGINDIR}"/*/; do
        if [[ -d "${dir}/.git" ]]; then
            echo "🔄 Updating ${dir:t}..."
            git -C "$dir" pull --ff-only --autostash --quiet || echo "Failed to update ${dir:t}"
        fi
    done
    echo -e "\n✨ All plugins updated!"
}

#---[ Initialization ]-----------------------------------------------
# Synchronous Loading
local plugin
for plugin in "${plugins[@]}"; do
    _zplugin_load "$plugin"
done

# Compinit
setopt local_options extendedglob

local zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d ${zcompdump:h} ]] || mkdir -p ${zcompdump:h}

if [[ -n ${zcompdump}(#qN.mh+24) ]]; then
    autoload -Uz compinit && compinit -d "$zcompdump"
    zcompile "$zcompdump" &!
else
    autoload -Uz compinit && compinit -C -d "$zcompdump"
fi

unsetopt extendedglob

# Asynchronous Loading 
if type zsh-defer >/dev/null 2>&1; then
    for plugin in "${deferred_plugins[@]}"; do
        zsh-defer _zplugin_load "$plugin"
    done
else
    for plugin in "${deferred_plugins[@]}"; do
        _zplugin_load "$plugin"
    done
fi
