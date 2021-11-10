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
    # dconf dump /org/gnome/shell/extensions/just-perfection/
    dconf write /org/gnome/shell/extensions/just-perfection/accessibility-menu false
    dconf write /org/gnome/shell/extensions/just-perfection/activities-button true
    dconf write /org/gnome/shell/extensions/just-perfection/activities-button-icon-monochrome true
    dconf write /org/gnome/shell/extensions/just-perfection/activities-button-label true
    dconf write /org/gnome/shell/extensions/just-perfection/aggregate-menu true
    dconf write /org/gnome/shell/extensions/just-perfection/animation 3
    dconf write /org/gnome/shell/extensions/just-perfection/app-menu true
    dconf write /org/gnome/shell/extensions/just-perfection/app-menu-icon true
    dconf write /org/gnome/shell/extensions/just-perfection/background-menu true
    dconf write /org/gnome/shell/extensions/just-perfection/clock-menu true
    dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position 0
    dconf write /org/gnome/shell/extensions/just-perfection/dash true
    dconf write /org/gnome/shell/extensions/just-perfection/dash-icon-size 48
    dconf write /org/gnome/shell/extensions/just-perfection/hot-corner false
    dconf write /org/gnome/shell/extensions/just-perfection/keyboard-layout true
    dconf write /org/gnome/shell/extensions/just-perfection/notification-banner-position 0
    dconf write /org/gnome/shell/extensions/just-perfection/osd true
    dconf write /org/gnome/shell/extensions/just-perfection/panel true
    dconf write /org/gnome/shell/extensions/just-perfection/panel-corner-size 1
    dconf write /org/gnome/shell/extensions/just-perfection/panel-notification-icon true
    dconf write /org/gnome/shell/extensions/just-perfection/power-icon true
    dconf write /org/gnome/shell/extensions/just-perfection/search true
    dconf write /org/gnome/shell/extensions/just-perfection/show-apps-button false
    dconf write /org/gnome/shell/extensions/just-perfection/startup-status 0
    dconf write /org/gnome/shell/extensions/just-perfection/theme false
    dconf write /org/gnome/shell/extensions/just-perfection/top-panel-position 0
    dconf write /org/gnome/shell/extensions/just-perfection/type-to-search true
    dconf write /org/gnome/shell/extensions/just-perfection/window-demands-attention-focus true
    dconf write /org/gnome/shell/extensions/just-perfection/window-picker-icon false
    dconf write /org/gnome/shell/extensions/just-perfection/window-preview-caption false
    dconf write /org/gnome/shell/extensions/just-perfection/workspace true
    dconf write /org/gnome/shell/extensions/just-perfection/workspace-background-corner-size 0
    dconf write /org/gnome/shell/extensions/just-perfection/workspace-popup true
    dconf write /org/gnome/shell/extensions/just-perfection/workspace-switcher-should-show false
    dconf write /org/gnome/shell/extensions/just-perfection/workspace-switcher-size 0
    dconf write /org/gnome/shell/extensions/just-perfection/workspace-wrap-around false
    dconf write /org/gnome/shell/extensions/just-perfection/workspaces-in-app-grid true
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
