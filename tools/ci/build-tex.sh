#!/bin/bash
set -e

# go to repository root
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR/../.."
ROOT_DIR=`pwd`

OUT_PDF_PATH="$ROOT_DIR/book/pdf"

build_tex() {
    DOC_PATH=$1
    CATEGORY=$2
    pushd "$ROOT_DIR/$DOC_PATH" >/dev/null
    echo "Entering $DOC_PATH ..."
    latexmk
    mkdir -p "$OUT_PDF_PATH/$CATEGORY"
    cp build/*.pdf "$OUT_PDF_PATH/$CATEGORY"
    echo "  Copied pdf output to $OUT_PDF_PATH/$CATEGORY"
    popd >/dev/null
    echo "Leaving $DOC_PATH ..."
}

make_booklet() {
    DOC_PATH=$1
    filename=$2

}

build_tex "Aides/cartes-sorts" aides
build_tex "Aides/cleric-book" aides
build_tex "Aides/mage-book" aides

### create booklets
pushd "$OUT_PDF_PATH/aides"
pdfbook2 --paper=a4paper -n livre_clerc.pdf
pdfbook2 --paper=a4paper -n livre_mage.pdf
popd

build_tex "Scenarii/Tomb-serpent-kings" scenarii
### create booklets
# first split document to have monster as self doc
# find page 
pushd "$OUT_PDF_PATH/scenarii"
page=`pdfinfo -dests Tombe_des_rois_serpents.pdf | grep chapter.5 | awk '{print $1;}'`
echo $page
pdfjam Tombe_des_rois_serpents.pdf 1-20 -o tdrs.pdf
pdfbook2 --paper=a4paper -n tdrs.pdf
pdfjam Tombe_des_rois_serpents.pdf 21- -o tdrs_monsters.pdf
pdfbook2 --paper=a4paper -n tdrs_monsters.pdf
rm tdrs.pdf tdrs_monsters.pdf
popd