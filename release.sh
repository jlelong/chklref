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
    echo '-- Creating an archive from the git repository'
    cwd=$(pwd)
    [[ -d "$LOCAL_TMPDIR" ]] && rm -rf "$LOCAL_TMPDIR"
    mkdir -p "$CHKLREF_DIR"
    cd "$CHKLREFGIT"
    git archive --format=tar master | tar -x -C "$CHKLREF_DIR"
    cd "$cwd"
}

compile_doc() {
    echo '-- Compiling the documentation'
    cwd=$(pwd)
    cd "$CHKLREF_DIR/doc"
    make
    cd "$cwd"
}

create_tds() {
    echo '-- Creating chklref.tds.zip'
    cwd=$(pwd)
    mkdir -p "$CHKLREF_DIR/chklref.tds"
    cd "$CHKLREF_DIR/chklref.tds"
    mkdir -p tex/latex/chklref
    mkdir -p doc/latex/chklref
    mkdir -p scripts/chklref
    cp ../chklref.sty tex/latex/chklref
    cp ../doc/chklref.{tex,pdf} doc/latex/chklref
    cp ../README.md doc/latex/chklref
    cp ../chklref.pl scripts/chklref
    cd ..
    zip -r chklref.tds.zip chklref.tds
    rm -rf chklref.tds
    cd "$cwd"
}

create_zip() {
    echo '-- Creating chklref.zip'
    cwd=$(pwd)
    cd "$CHKLREF_DIR/.."
    zip -r chklref.zip chklref
    cd "$cwd"
}

git_archive
compile_doc
create_tds
create_zip
