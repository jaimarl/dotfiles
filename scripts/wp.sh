#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wallpaper"

for cmd in fzf chafa awww-daemon; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: '$cmd' is not installed"
        exit 1
    fi
done

MODE=${1:-"select"}

case "$MODE" in
    set)
        if [ -n "$2" ]; then
            WALLPAPER="$2"
        else
            echo "Usage: $0 set <file-path>"
            exit 1
        fi
        ;;
    random)
        CURRENT_WALL=""
        if [ -L "$CACHE/current.png" ]; then
            CURRENT_WALL=$(readlink "$CACHE/current.png")
        fi

        ALL_WALLS=$(find "$WALL_DIR" -type f | grep -E "\.(jpg|jpeg|png|webp|gif)$")
        
        if [ -n "$CURRENT_WALL" ]; then
            RANDOM_WALL=$(echo "$ALL_WALLS" | grep -vF "$CURRENT_WALL" | shuf -n 1)
        else
            RANDOM_WALL=$(echo "$ALL_WALLS" | shuf -n 1)
        fi

        if [ -n "$RANDOM_WALL" ]; then
            WALLPAPER="$RANDOM_WALL"
        else
            echo "No images found in $WALL_DIR"
            exit 1
        fi
        ;;
    select)
        SELECTION=$( (
            cd "$WALL_DIR" || exit 1
            
            find . -mindepth 2 -type f | grep -E "\.(jpg|jpeg|png|webp|gif)$" | sort | while IFS= read -r file; do
                rel_path="${file#./}"
                dir_part=$(dirname "$rel_path")
                base_part=$(basename "$rel_path")
                printf "\033[2m%s/\033[0m%s\t%s\n" "$dir_part" "$base_part" "$WALL_DIR/$rel_path"
            done

            find . -maxdepth 1 -type f | grep -E "\.(jpg|jpeg|png|webp|gif)$" | sort | while IFS= read -r file; do
                rel_path="${file#./}"
                printf "%s\t%s\n" "$rel_path" "$WALL_DIR/$rel_path"
            done
        ) | fzf --ansi \
                --prompt="Select wallpaper: " \
                --delimiter="\t" \
                --with-nth=1 \
                --preview "chafa -s ${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES} {2}" \
                --preview-window=right:60% \
                --layout=reverse )

        if [ -z "$SELECTION" ]; then
            exit 0
        fi 

        WALLPAPER=$(printf "%s\n" "$SELECTION" | cut -f2)
        ;;
    *)
        echo "Usage: $0 {set|random|select}"
        exit 1
        ;;
esac

if [[ -z $(pgrep awww-daemon) ]]; then
    awww-daemon --no-cache &
fi

ABS_PATH=$(realpath "$WALLPAPER")

mkdir -p "$CACHE"
ln -sf "$ABS_PATH" "$CACHE/current.png"
awww img "$ABS_PATH" \
    --transition-type grow \
    --transition-pos 0.5,0.99 \
    --transition-step 90 \
    --transition-duration 1 \
    --transition-fps 144
