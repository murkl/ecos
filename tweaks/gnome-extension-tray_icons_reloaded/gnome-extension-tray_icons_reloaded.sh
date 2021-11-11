#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    remove
    curl -Ls "https://github.com/MartinPL/Tray-Icons-Reloaded/releases/download/17/trayIconsReloaded@selfmade.pl.zip" -o "$TWEAK_CACHE_DIR/trayIconsReloaded@selfmade.pl.zip"
    unzip "$TWEAK_CACHE_DIR/trayIconsReloaded@selfmade.pl.zip" -d "$HOME/.local/share/gnome-shell/extensions/trayIconsReloaded@selfmade.pl"
    gnome-extensions enable "trayIconsReloaded@selfmade.pl"

    # Configuration
    # dconf dump /org/gnome/shell/extensions/trayIconsReloaded/ > dconf.dump
    local dconf_path='/org/gnome/shell/extensions/trayIconsReloaded/'
    dconf reset -f "$dconf_path"
    dconf load "$dconf_path" <"$TWEAK_RES_DIR/dconf.dump"
}

remove() {
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/trayIconsReloaded@selfmade.pl*
}

update() {
    install
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
