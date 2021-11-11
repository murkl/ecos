#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    remove
    rm -rf "$TWEAK_CACHE_DIR/repo"
    git clone "https://github.com/home-sweet-gnome/dash-to-panel.git" "$TWEAK_CACHE_DIR/repo"
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    make install
    gnome-extensions enable "dash-to-panel@jderose9.github.com"
    # dash-to-panel Workaround for Bug: https://github.com/home-sweet-gnome/dash-to-panel/issues/1437
    #sudo curl -Ls https://raw.githubusercontent.com/home-sweet-gnome/dash-to-panel/81af73b23911cbbdce807566ed6ef2a864417d6c/overview.js -o /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/overview.js

    # Configuration
    # dconf dump /org/gnome/shell/extensions/dash-to-panel/ > dconf.dump
    local dconf_path='/org/gnome/shell/extensions/dash-to-panel/'
    dconf reset -f "$dconf_path"
    dconf load "$dconf_path" <"$TWEAK_RES_DIR/dconf.dump"
}

remove() {
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/dash-to-panel@jderose9.github.com*
}

update() {
    cd "$TWEAK_CACHE_DIR/repo" || exit 1
    git pull
    remove
    make install
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
