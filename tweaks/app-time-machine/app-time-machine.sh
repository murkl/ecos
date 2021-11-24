#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

TWEAK_REPO_DIR="$TWEAK_CACHE_DIR/repo"
TWEAK_GIT_URL="https://github.com/murkl/time-machine.git"

install() {
    rm -rf "$TWEAK_REPO_DIR"
    mkdir -p "$TWEAK_REPO_DIR"
    git clone "$TWEAK_GIT_URL" "$TWEAK_REPO_DIR"
    cd "$TWEAK_REPO_DIR" || return 1
    ./time-machine --install
}

remove() {
    cd "$TWEAK_REPO_DIR" || return 1
    ./time-machine --remove
    rm -rf "$TWEAK_REPO_DIR"
}

update() {
    cd "$TWEAK_REPO_DIR" || return 1
    git reset --hard
    git pull
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
