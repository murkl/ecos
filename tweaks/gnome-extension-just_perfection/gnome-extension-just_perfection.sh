#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    remove
    mkdir -p "$HOME/.local/share/gnome-shell/extensions/"
    rm -rf "$TWEAK_CACHE_DIR/repo"
    git clone "https://gitlab.gnome.org/jrahmatzadeh/just-perfection.git" "$TWEAK_CACHE_DIR/repo"
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    ./scripts/build.sh -i

    # Configuration
    # dconf dump /org/gnome/shell/extensions/just-perfection/ > dconf.dump
    local dconf_path='/org/gnome/shell/extensions/just-perfection/'
    dconf reset -f "$dconf_path"
    dconf load "$dconf_path" <"$TWEAK_RES_DIR/dconf.dump"

    # Enable
    gnome-extensions enable "just-perfection-desktop@just-perfection"
}

remove() {
    gnome-extensions disable "just-perfection-desktop@just-perfection"
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/just-perfection-desktop@just-perfection*
}

update() {
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    git pull
    remove
    ./scripts/build.sh -i
    gnome-extensions enable "just-perfection-desktop@just-perfection"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
