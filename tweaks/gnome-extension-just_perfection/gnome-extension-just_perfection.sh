#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    remove
    rm -rf "$TWEAK_CACHE_DIR/repo"
    git clone "https://gitlab.gnome.org/jrahmatzadeh/just-perfection.git" "$TWEAK_CACHE_DIR/repo"
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    ./scripts/build.sh -i
    gnome-extensions enable "just-perfection-desktop@just-perfection"
}

remove() {
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/just-perfection-desktop@just-perfection*
}

update() {
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    git pull
    remove
    ./scripts/build.sh -i
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
