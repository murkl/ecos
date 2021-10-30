#!/bin/bash
TWEAK_HOME_URL="https://raw.githubusercontent.com/murkl/ecos/main/tweaks/synology-drive/"

install() {
    paru --noconfirm --needed --sudoloop -S synology-drive
    update
}

remove() {
    paru -Rsn synology-drive
    rm -rf $HOME/.SynologyDrive/
}

update() {
    curl -L "$TWEAK_HOME_URL/cloud-sync.png" -o $HOME/.SynologyDrive/SynologyDrive.app/images/tray/win-linux-black/syncing.png
    curl -L "$TWEAK_HOME_URL/cloud-normal.png" -o $HOME/.SynologyDrive/SynologyDrive.app/images/tray/win-linux-black/uptodate.png
    curl -L "$TWEAK_HOME_URL/cloud-normal.png" -o $HOME/.SynologyDrive/SynologyDrive.app/images/tray/win-linux-black/normal.png
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
