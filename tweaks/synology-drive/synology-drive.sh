#!/bin/bash
TWEAK_RES_URL="$2"

install() {
    paru --noconfirm --needed --sudoloop -S synology-drive
    update
}

remove() {
    paru -Rsn synology-drive
}

update() {
    local drive_icons_dir="$HOME/.SynologyDrive/SynologyDrive.app/images/tray/win-linux-black"
    curl -L "$TWEAK_RES_URL/syncing.png" -o "$drive_icons_dir/syncing.png"
    curl -L "$TWEAK_RES_URL/uptodate.png" -o "$drive_icons_dir/uptodate.png"
    curl -L "$TWEAK_RES_URL/normal.png" -o "$drive_icons_dir/normal.png"
    curl -L "$TWEAK_RES_URL/abnormal.png" -o "$drive_icons_dir/abnormal.png"
    curl -L "$TWEAK_RES_URL/disconnect.png" -o "$drive_icons_dir/disconnect.png"
    curl -L "$TWEAK_RES_URL/notification.png" -o "$drive_icons_dir/notification.png"
    curl -L "$TWEAK_RES_URL/pause.png" -o "$drive_icons_dir/pause.png"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
