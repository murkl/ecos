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

    # Configuration
    dconf write accessibility-menu false
    dconf write activities-button true
    dconf write activities-button-icon-monochrome true
    dconf write activities-button-label true
    dconf write aggregate-menu true
    dconf write animation 3
    dconf write app-menu true
    dconf write app-menu-icon true
    dconf write background-menu true
    dconf write clock-menu true
    dconf write clock-menu-position 0
    dconf write dash true
    dconf write dash-icon-size 48
    dconf write hot-corner false
    dconf write keyboard-layout true
    dconf write notification-banner-position 0
    dconf write osd true
    dconf write panel true
    dconf write panel-corner-size 1
    dconf write panel-notification-icon true
    dconf write power-icon true
    dconf write search true
    dconf write show-apps-button false
    dconf write startup-status 0
    dconf write theme false
    dconf write top-panel-position 0
    dconf write type-to-search true
    dconf write window-demands-attention-focus true
    dconf write window-picker-icon false
    dconf write window-preview-caption false
    dconf write workspace true
    dconf write workspace-background-corner-size 0
    dconf write workspace-popup true
    dconf write workspace-switcher-should-show false
    dconf write workspace-switcher-size 0
    dconf write workspace-wrap-around false
    dconf write workspaces-in-app-grid true
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
