#!/bin/bash
DIRNAME=$(dirname $(readlink -f "$0"))

if [ "$#" -eq 0 ]; then
    echo "Использование: ./install.sh [config_1] [config_2] ..."
    echo "Доступные конфиги:"
    echo " [nvim]      -  Neovim"
    echo " [pipewire]  -  Pipewire mono playback"
    echo " [yazi]      -  Yazi"

    exit 0
fi

for config in "$@"; do
    case "$config" in
        nvim)
            echo "--- Установка Neovim ---"

            sudo pacman -S --needed luarocks

            rm -rf ~/.config/nvim
            ln -sf "$DIRNAME"/nvim ~/.config
        ;;
        pipewire)
            echo "--- Установка Pipewire ---"

            mkdir -p ~/.config/pipewire/pipewire.conf.d
            ln -sf "$DIRNAME"/pipewire/pipewire.conf.d/mono-playback.conf ~/.config/pipewire/pipewire.conf.d
        ;;
        yazi)
            echo "--- Установка Yazi ---"

            sudo pacman -S --needed 7zip mediainfo trash-cli wl-clipboard

            rm -rf ~/.config/yazi
            ln -sf "$DIRNAME"/yazi ~/.config
        ;;
        *)
            echo " Неизвестный конфиг: $config"
        ;;
    esac
done

echo " Установка завершена"
