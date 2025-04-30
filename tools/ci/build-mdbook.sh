#!/bin/sh
set -e

cd SRD-md
mdbook build
cd ..
cp -r SRD-md/book/* ./book
