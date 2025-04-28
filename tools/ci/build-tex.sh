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

build_tex "Aides/cartes-sorts" aides
build_tex "Aides/cleric-book" aides
build_tex "Aides/mage-book" aides

build_tex "Scenarii/Tomb-serpent-kings" scenarii

