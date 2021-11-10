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
    # dconf dump /org/gnome/shell/extensions/dash-to-panel/
    dconf write /org/gnome/shell/extensions/dash-to-panel/animate-app-switch true
    dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover false
    dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-convexity {'RIPPLE': 2.0, 'PLANK': 1.0, 'SIMPLE': 0.0}
    dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-extent {'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}
    dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-type 'SIMPLE'
    dconf write /org/gnome/shell/extensions/dash-to-panel/animate-window-launch true
    dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-margin 4
    dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-padding 6
    dconf write /org/gnome/shell/extensions/dash-to-panel/available-monitors [0]
    dconf write /org/gnome/shell/extensions/dash-to-panel/dot-color-dominant true
    dconf write /org/gnome/shell/extensions/dash-to-panel/dot-color-override false
    dconf write /org/gnome/shell/extensions/dash-to-panel/dot-position 'BOTTOM'
    dconf write /org/gnome/shell/extensions/dash-to-panel/dot-size 2
    dconf write /org/gnome/shell/extensions/dash-to-panel/dot-style-focused 'SEGMENTED'
    dconf write /org/gnome/shell/extensions/dash-to-panel/dot-style-unfocused 'SEGMENTED'
    dconf write /org/gnome/shell/extensions/dash-to-panel/focus-highlight true
    dconf write /org/gnome/shell/extensions/dash-to-panel/focus-highlight-dominant true
    dconf write /org/gnome/shell/extensions/dash-to-panel/hide-overview-on-startup true
    dconf write /org/gnome/shell/extensions/dash-to-panel/hotkeys-overlay-combo 'TEMPORARILY'
    dconf write /org/gnome/shell/extensions/dash-to-panel/leftbox-padding -1
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-anchors '{"0":"MIDDLE"}'
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-element-positions '{"0":[{"element":"activitiesButton","visible":true,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"leftBox","visible":false,"position":"centerMonitor"},{"element":"showAppsButton","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-lengths '{"0":100}'
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-positions '{"0":"TOP"}'
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-sizes '{"0":32}'
    dconf write /org/gnome/shell/extensions/dash-to-panel/preview-use-custom-opacity true
    dconf write /org/gnome/shell/extensions/dash-to-panel/secondarymenu-contains-showdetails false
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-appmenu false
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-apps-icon-file ''
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-apps-icon-side-padding 8
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-apps-override-escape true
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-favorites true
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-favorites-all-monitors true
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-tooltip false
    dconf write /org/gnome/shell/extensions/dash-to-panel/show-window-previews false
    dconf write /org/gnome/shell/extensions/dash-to-panel/status-icon-padding -1
    dconf write /org/gnome/shell/extensions/dash-to-panel/stockgs-keep-dash false
    dconf write /org/gnome/shell/extensions/dash-to-panel/stockgs-keep-top-panel false
    dconf write /org/gnome/shell/extensions/dash-to-panel/stockgs-panelbtn-click-only false
    dconf write /org/gnome/shell/extensions/dash-to-panel/trans-use-custom-bg false
    dconf write /org/gnome/shell/extensions/dash-to-panel/trans-use-custom-gradient false
    dconf write /org/gnome/shell/extensions/dash-to-panel/trans-use-custom-opacity false
    dconf write /org/gnome/shell/extensions/dash-to-panel/tray-padding -1
    dconf write /org/gnome/shell/extensions/dash-to-panel/window-preview-title-position 'TOP'
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
