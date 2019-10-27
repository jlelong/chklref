#!/bin/bash

# This script creates a new releas of chklref
CWD="$(pwd)/$0"
CHKLREFGIT=$(dirname $"CWD")
DATE=$(date +%Y%m%d)
# Local temporary directory
LOCAL_TMPDIR="$HOME/tmp/chklref-$DATE"
CHKLREF_DIR="$LOCAL_TMPDIR/chklref"

# Perform git archive
git_archive() {
    cwd=$(pwd)
    [[ -d "$LOCAL_TMPDIR" ]] && rm -rf "$LOCAL_TMPDIR"
    mkdir -p "$CHKLREF_DIR"
    cd "$CHKLREFGIT"
    git archive --format=tar master | tar -x -C "$CHKLREF_DIR"
    cd "$cwd"
}

compile_doc() {
    cwd=$(pwd)
    cd "$CHKLREF_DIR/doc"
    make
    cd "$cwd"
}

create_tds() {
    cwd=$(pwd)
    mkdir -p "$CHKLREF_DIR/chklref.tds"
    cd "$CHKLREF_DIR/chklref.tds"
    mkdir -p tex/latex/chklref
    mkdir -p doc/latex/chklref
    mkdir -p scripts/chklref
    cp ../chklref.sty tex/latex/chklref
    cp ../doc/chklref.{tex,pdf} doc/latex/chklref
    cp ../chklref.pl scripts/chklref
    cd ..
    zip -r chklref.tds.zip chklref.tds
    rm -rf chklref.tds
    cd "$cwd"
}

git_archive
compile_doc
create_tds
zip -r "$CHKLREF_DIR.zip" "$CHKLREF_DIR"