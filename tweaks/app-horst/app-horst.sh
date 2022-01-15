#!/bin/bash
TWEAK_RES_DIR="$2" && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi
TWEAK_CACHE_DIR="$3" && if [ -z "$3" ]; then TWEAK_CACHE_DIR="$(pwd)"; fi

TWEAK_REPO_DIR="$TWEAK_CACHE_DIR/repo"
TWEAK_GIT_URL="https://github.com/murkl/horst.git"

install() {
    rm -rf "$TWEAK_REPO_DIR"
    mkdir -p "$TWEAK_REPO_DIR"
    git clone "$TWEAK_GIT_URL" "$TWEAK_REPO_DIR"
    cd "$TWEAK_REPO_DIR" || exit 1
    ./horst --install
}

remove() {
    cd "$TWEAK_REPO_DIR" || exit 1
    ./horst --remove
    rm -rf "$TWEAK_REPO_DIR"
}

update() {
    cd "$TWEAK_REPO_DIR" || exit 1
    git reset --hard
    git pull
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
