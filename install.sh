#!/usr/bin/env bash
set -e

DOTS=$(dirname $(readlink -f "$0"))
CONF="$HOME/.config"

show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  [pipewire]    Pipewire Mono Playback"
    echo "  [starship]    Starship Prompt"
    echo "  [yazi]        Yazi File Manager"
    echo "  [zsh]         Zsh Shell"
}

backup() {
    FILE="$1"
    if [[ -e "$1" && ! -L "$1" ]]; then
        echo " > Created backup for \"$1\""
        mv "$1" "$1".bak
    fi
}

if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

for arg; do
    case "$arg" in
        pipewire)
            dir="$CONF/pipewire/pipewire.conf.d"
            mkdir -p "$dir"
            ln -sf "$DOTS/pipewire/mono-playback.conf" "$dir"
            echo "Installed Pipewire Mono Playback"
            ;;
        starship)
            backup "$CONF/starship.toml"
            ln -sf "$DOTS/starship/starship.toml" "$CONF"
            echo "Installed Starship"
            ;;
        yazi)
            backup "$CONF/yazi"
            ln -sf "$DOTS/yazi" "$CONF"
            echo "Installed Yazi"
            ;;
        zsh)
            backup "$HOME/.zshrc"
            backup "$HOME/.zsh_plugins.txt"
            ln -sf "$DOTS/zsh/.zshrc" "$HOME"
            ln -sf "$DOTS/zsh/.zsh_plugins.txt" "$HOME"
            echo "Installed Zsh"
            ;;
        *)
            echo "Invalid config \"$arg\""
            ;;
    esac
done
