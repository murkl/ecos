#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

EXTENSION_NAME="dash-to-dock@micxgx.gmail.com"
EXTENSION_REPO="https://github.com/micheleg/dash-to-dock.git"
EXTENSION_DCONF="/org/gnome/shell/extensions/dash-to-dock/"

install() {
    mkdir -p "$HOME/.local/share/gnome-shell/extensions/"
    rm -rf "$TWEAK_CACHE_DIR/repo"

    git clone "$EXTENSION_REPO" "$TWEAK_CACHE_DIR/repo"
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    make
    make install

    # Configuration
    # dconf dump /org/gnome/shell/extensions/dash-to-dock/ > dconf.dump
    dconf reset -f "$EXTENSION_DCONF"
    dconf load "$EXTENSION_DCONF" <"$TWEAK_RES_DIR/dconf.dump"

    # Enable
    gnome-extensions enable "$EXTENSION_NAME"
}

remove() {
    gnome-extensions disable "$EXTENSION_NAME"
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/${EXTENSION_NAME}*
}

update() {
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    git pull
    make
    make install
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
