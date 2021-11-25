#!/bin/bash
# https://github.com/RaphaelRochet/arch-update/wiki

TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    remove
    mkdir -p "$HOME/.local/share/gnome-shell/extensions/"
    curl -Ls "https://github.com/RaphaelRochet/arch-update/releases/download/v45/arch-update@RaphaelRochet.zip" -o "$TWEAK_CACHE_DIR/arch-update@RaphaelRochet.zip"
    unzip "$TWEAK_CACHE_DIR/arch-update@RaphaelRochet.zip" -d "$HOME/.local/share/gnome-shell/extensions/arch-update@RaphaelRochet"

    # Configuration
    # dconf dump /org/gnome/shell/extensions/arch-update/ > dconf.dump
    local dconf_path='/org/gnome/shell/extensions/arch-update/'
    dconf reset -f "$dconf_path"
    dconf load "$dconf_path" <"$TWEAK_RES_DIR/dconf.dump"

    # Enable
    gnome-extensions enable "arch-update@RaphaelRochet"
}

remove() {
    gnome-extensions disable "arch-update@RaphaelRochet"
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/arch-update@RaphaelRochet*
}

update() {
    echo "Nothing to do..."
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
