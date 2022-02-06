#!/bin/bash

# Icon format:  png
# Icon size:    72x72

TWEAK_RES_DIR="$2" && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi

install() {
    paru --noconfirm --needed --sudoloop -S synology-drive
    update
}

remove() {
    if pacman -Qi synology-drive >/dev/null; then
        paru -Rsn synology-drive
    fi
}

update() {
    local drive_icons_dir="$HOME/.SynologyDrive/SynologyDrive.app/images/tray/normal"
    if [ -d "$drive_icons_dir" ]; then
        cp -f "$TWEAK_RES_DIR/syncing.png" "$drive_icons_dir/syncing.png"
        cp -f "$TWEAK_RES_DIR/uptodate.png" "$drive_icons_dir/uptodate.png"
        cp -f "$TWEAK_RES_DIR/normal.png" "$drive_icons_dir/normal.png"
        cp -f "$TWEAK_RES_DIR/abnormal.png" "$drive_icons_dir/abnormal.png"
        cp -f "$TWEAK_RES_DIR/disconnect.png" "$drive_icons_dir/disconnect.png"
        cp -f "$TWEAK_RES_DIR/notification.png" "$drive_icons_dir/notification.png"
        cp -f "$TWEAK_RES_DIR/pause.png" "$drive_icons_dir/pause.png"
    fi
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
