#!/bin/bash
# https://github.com/RaphaelRochet/arch-update/wiki

TWEAK_RES_DIR="$2" && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi
TWEAK_CACHE_DIR="$3" && if [ -z "$3" ]; then TWEAK_CACHE_DIR="$(pwd)"; fi

# https://github.com/RaphaelRochet/arch-update/releases
URL="https://github.com/RaphaelRochet/arch-update/releases/download/v47/arch-update@RaphaelRochet.zip"

install() {
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/arch-update@RaphaelRochet*

    mkdir -p "$HOME/.local/share/gnome-shell/extensions/"
    curl -Ls "$URL" -o "$TWEAK_CACHE_DIR/arch-update@RaphaelRochet.zip"
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
    remove
    install
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
