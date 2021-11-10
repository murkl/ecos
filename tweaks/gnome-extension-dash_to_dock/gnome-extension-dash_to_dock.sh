#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    git clone "https://github.com/home-sweet-gnome/dash-to-panel.git" "$TWEAK_CACHE_DIR/repo"
}

remove() {
    rm -rf "$HOME/.local/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com_v44"
}

update() {
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    remove
    make install
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
