#!/bin/bash
set -e

OUT_PDF_PATH="`pwd`/book/pdf/"

build_tex() {
    DOC_PATH=$1
    pushd $DOC_PATH >/dev/null
    echo "Entering $DOC_PATH ..."
    latexmk
    cp build/*.pdf "$OUT_PDF_PATH"
    popd >/dev/null
    echo "Leaving $DOC_PATH ..."
}

mkdir -p "$OUT_PDF_PATH"
build_tex "Aides/cartes-sorts"
