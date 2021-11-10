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
    dconf write animate-app-switch true
    dconf write animate-appicon-hover false
    dconf write animate-appicon-hover-animation-convexity {'RIPPLE': 2.0, 'PLANK': 1.0, 'SIMPLE': 0.0}
    dconf write animate-appicon-hover-animation-extent {'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}
    dconf write animate-appicon-hover-animation-type 'SIMPLE'
    dconf write animate-window-launch true
    dconf write appicon-margin 4
    dconf write appicon-padding 6
    dconf write available-monitors [0]
    dconf write dot-color-dominant true
    dconf write dot-color-override false
    dconf write dot-position 'BOTTOM'
    dconf write dot-size 2
    dconf write dot-style-focused 'SEGMENTED'
    dconf write dot-style-unfocused 'SEGMENTED'
    dconf write focus-highlight true
    dconf write focus-highlight-dominant true
    dconf write hide-overview-on-startup true
    dconf write hotkeys-overlay-combo 'TEMPORARILY'
    dconf write leftbox-padding -1
    dconf write panel-anchors '{"0":"MIDDLE"}'
    dconf write panel-element-positions '{"0":[{"element":"activitiesButton","visible":true,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"leftBox","visible":false,"position":"centerMonitor"},{"element":"showAppsButton","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'
    dconf write panel-lengths '{"0":100}'
    dconf write panel-positions '{"0":"TOP"}'
    dconf write panel-sizes '{"0":32}'
    dconf write preview-use-custom-opacity true
    dconf write secondarymenu-contains-showdetails false
    dconf write show-appmenu false
    dconf write show-apps-icon-file ''
    dconf write show-apps-icon-side-padding 8
    dconf write show-apps-override-escape true
    dconf write show-favorites true
    dconf write show-favorites-all-monitors true
    dconf write show-tooltip false
    dconf write show-window-previews false
    dconf write status-icon-padding -1
    dconf write stockgs-keep-dash false
    dconf write stockgs-keep-top-panel false
    dconf write stockgs-panelbtn-click-only false
    dconf write trans-use-custom-bg false
    dconf write trans-use-custom-gradient false
    dconf write trans-use-custom-opacity false
    dconf write tray-padding -1
    dconf write window-preview-title-position 'TOP'
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
