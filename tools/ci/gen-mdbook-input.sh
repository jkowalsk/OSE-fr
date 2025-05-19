#!/bin/sh
set -e

## run build-tex.sh then use this to generate mdbook input aides.md

function get_description() {
    filebase=$1
    case $filebase in
        spell_card)
        desc="Cartes de sort pour Mage and Clerc."
        ;;
        livre_clerc)
        desc="Règles spéciﬁques au clerc et listes de sort"
        ;;
        livre_mage)
        desc="Règles spéciﬁques au magicien et listes de sort"
        ;;
       alt_character-gen)
        desc="Méthode alternative de création de personnage, sur le modèle des playbooks de [Beyond the Wall](https://www.flatlandgames.com/btw/)"
        ;;
        Tombe_des_rois_serpents)
        desc="**La Tombe des Rois Serpents** : Scénario \"tutoriel\" pour débutants. [source](https://coinsandscrolls.blogspot.com/2017/06/osr-tomb-of-serpent-kings-megapost.html)"
        ;;
        tdrs-book)
        desc="**La Tombe des Rois Serpents** : Scénario, Livret imprimable. La description des monstres y est absente"
        ;;
        tdrs_monsters-book)
        desc="**La Tombe des Rois Serpents** : Description des monstres. Livret imprimable"
        ;;
        *)
        desc=""
        ;;
    esac
    echo $desc
}


function gen_aides_md() {
    echo "| **Fichier**| **Livret Imprimable**| **Description** |"  >> "$OUT_MD_FILE"
    echo "| :--------: | :------------------: | :-------------- |"  >> "$OUT_MD_FILE"
    for file in *.pdf; do
    if [ -f "$file" ]; then
        filebase=${file%.pdf}
        $MAGICK $file[0] -resize 20% -flatten -frame 1x1 "$OUT_MD_PATH/${filebase}.png"  >/dev/null
        echo "created $OUT_MD_PATH/${filebase}.png"
        if [[ "$filebase" != *-book ]]
        then
            description=$(get_description ${filebase})
             if [ -f "$filebase-book.pdf" ]; then
                booklet_link="[![$filebase-book.png]($filebase-book.png)]($category/$filebase-book.pdf)"
            else
                booklet_link=""
            fi
            echo "| [![$filebase.png]($filebase.png)]($category/$filebase.pdf) | $booklet_link | $description  |"  >> "$OUT_MD_FILE"
        fi
    fi
    done
}

function gen_aides_other() {
    echo "| **Fichier**| **Description** |"  >> "$OUT_MD_FILE"
    echo "| --: | :-- |"  >> "$OUT_MD_FILE"
    for file in *.pdf; do
    if [ -f "$file" ]; then
        filebase=${file%.pdf}
        $MAGICK $file[0] -resize 20% -flatten -frame 1x1 "$OUT_MD_PATH/${filebase}.png"  >/dev/null
        echo "created $OUT_MD_PATH/${filebase}.png"
        description=$(get_description ${filebase})
        echo "| [![$filebase.png]($filebase.png)]($category/$filebase.pdf) |  $description  |"  >> "$OUT_MD_FILE"
    fi
    done
}

function gen_category_md() {
    dir=$1
    category="${dir##*/}"
    echo ""  >> "$OUT_MD_FILE"
    echo "## $category"  >> "$OUT_MD_FILE"
    echo ""  >> "$OUT_MD_FILE"
    cd "$dir"
    case $category in
        aides)
            gen_aides_md
        ;;
        *)
            gen_aides_other 
        ;;
    esac    
    cd "$ROOT_DIR"
}

# go to repository root
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR/../.."
ROOT_DIR=`pwd`
cd "$ROOT_DIR"

MAGICK=magick
if ! command -v $MAGICK 2>&1 >/dev/null
then
    MAGICK=convert
fi

OUT_PDF_PATH="$ROOT_DIR/book/pdf"
OUT_MD_PATH="$ROOT_DIR/SRD-md/src/pdf"
OUT_MD_FILE="$OUT_MD_PATH/aides.inc.md"
rm -f "$OUT_MD_FILE"
for dir in "$OUT_PDF_PATH"/*; do
    if [ -d "$dir" ]; then
        gen_category_md "$dir"
    fi
done
 echo "created $OUT_MD_FILE"
