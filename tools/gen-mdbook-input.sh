#!/bin/bash
set -e

## run build-tex.sh then use this to generate mdbook input aides.md

function get_description() {
    filebase=$1
    case $filebase in
        spell_card)
        desc="Cartes de sort pour Mage and Clerc, à imprimer"
        ;;
        livre_clerc)
        desc="Règles spéciﬁques au clerc et listes de sort"
        ;;
        livre_mage)
        desc="Règles spéciﬁques au magicien et listes de sort"
        ;;
        *)
        desc=""
        ;;
    esac
    echo $desc
}

function gen_category_md() {
    dir=$1
    category="${dir##*/}"
    echo ""  >> "$OUT_MD_FILE"
    echo "## $category"  >> "$OUT_MD_FILE"
    echo ""  >> "$OUT_MD_FILE"
    pushd "$dir" >/dev/null
    echo "| **Fichier**| **Description** |"  >> "$OUT_MD_FILE"
    echo "| -- | :-- |"  >> "$OUT_MD_FILE"
    for file in *.pdf; do
    if [ -f "$file" ]; then
        filebase=${file%.pdf}
        magick $file[0] -resize 20% -flatten -frame 1x1 "$OUT_MD_PATH/${filebase}.png"  >/dev/null
        description=$(get_description ${filebase})
        echo "| [![$filebase.png]($filebase.png)]($filebase.pdf) |  $description  |"  >> "$OUT_MD_FILE"
    fi
    done
    popd >/dev/null
}

# go to repository root
ROOT_DIR=`git rev-parse --show-toplevel`
cd "$ROOT_DIR"

OUT_PDF_PATH="$ROOT_DIR/book/pdf"
OUT_MD_PATH="$ROOT_DIR/SRD-md/src/pdf"
OUT_MD_FILE="$OUT_MD_PATH/aides.md"

echo "# Aide de jeu" > "$OUT_MD_FILE"

for dir in "$OUT_PDF_PATH"/*; do
    if [ -d "$dir" ]; then
        gen_category_md "$dir"
    fi
done
