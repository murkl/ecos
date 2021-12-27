#!/bin/bash
# dconf dump /org/gnome/shell/extensions/blur-my-shell/ > dconf.dump

TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

EXTENSION_REPO="https://github.com/aunetx/blur-my-shell"
EXTENSION_NAME="blur-my-shell@aunetx"
EXTENSION_DCONF="blur-my-shell"

install() {
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/$EXTENSION_NAME*
    mkdir -p "$HOME/.local/share/gnome-shell/extensions/"
    rm -rf "$TWEAK_CACHE_DIR/repo"
    git clone "$EXTENSION_REPO" "$TWEAK_CACHE_DIR/repo"
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    make install

    # Configuration
    local dconf_path="/org/gnome/shell/extensions/$EXTENSION_DCONF/"
    dconf reset -f "$dconf_path"
    dconf load "$dconf_path" <"$TWEAK_RES_DIR/dconf.dump"

    # Enable
    gnome-extensions enable "$EXTENSION_NAME"
}

remove() {
    gnome-extensions disable "$EXTENSION_NAME"
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/$EXTENSION_NAME*
}

update() {
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    git pull
    make install
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
