#!/bin/sh
set -e

cd SRD-md
mdbook build
cd ..
mv SRD-md/book .