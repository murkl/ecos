#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    remove
    curl -Ls "https://github.com/MartinPL/Tray-Icons-Reloaded/releases/download/17/trayIconsReloaded@selfmade.pl.zip" -o "$TWEAK_CACHE_DIR/trayIconsReloaded@selfmade.pl.zip"
    unzip "$TWEAK_CACHE_DIR/trayIconsReloaded@selfmade.pl.zip" -d "$HOME/.local/share/gnome-shell/extensions/trayIconsReloaded@selfmade.pl"
    gnome-extensions enable "trayIconsReloaded@selfmade.pl"

    # Configuration
    # dconf dump /org/gnome/shell/extensions/trayIconsReloaded/
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-brightness 20
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-contrast 20
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-margin-horizontal 0
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-margin-vertical 0
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-padding-horizontal 10
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-padding-vertical 0
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-saturation 0
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-size 16
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/icons-limit 4
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/invoke-to-workspace true
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/position-weight -1
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/tray-margin-left 0
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/tray-margin-right 0
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/tray-position 'right'
    dconf write /org/gnome/shell/extensions/trayIconsReloaded/wine-behavior true
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
