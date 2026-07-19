#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SOURCE_DIR="$ROOT/resources/skins/Main/media/script.plex/buttons/player/modern"
TARGET_DIR="$ROOT/resources/skins/Main/media/script.plex/buttons/player/modern-focused"

mkdir -p "$TARGET_DIR"

for source in "$SOURCE_DIR"/*.png; do
    name=$(basename "$source")
    target="$TARGET_DIR/$name"
    mask=$(mktemp "${TMPDIR:-/tmp}/plex-osd-mask.XXXXXX.png")
    glyph=$(mktemp "${TMPDIR:-/tmp}/plex-osd-glyph.XXXXXX.png")

    magick "$source" -alpha extract "$mask"
    magick -size 180x145 xc:black "$mask" -compose CopyOpacity -composite "$glyph"
    magick -size 180x145 xc:none \
        -fill '#F2F2F2' -draw 'circle 90,72.5 90,29.5' \
        "$glyph" -compose Over -composite "$target"

    rm -f "$mask" "$glyph"
done

echo "generated $(find "$TARGET_DIR" -type f -name '*.png' | wc -l | tr -d ' ') focused OSD buttons"
