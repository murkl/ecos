#!/bin/bash

TWEAK_RES_DIR="$2" && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi
TWEAK_CACHE_DIR="$3" && if [ -z "$3" ]; then TWEAK_CACHE_DIR="$(pwd)"; fi

install() {
    # https://github.com/theinfiniterick/theming-grub-themes

    local grub_cfg="/etc/default/grub"
    local cfg_key="GRUB_THEME"
    local cfg_value="/boot/grub/theme/bigsur/theme.txt"

    sudo mkdir -p /boot/grub/theme
    cp -r "$TWEAK_RES_DIR/bigsur" /boot/grub/theme/bigsur

    if ! grep -qrnw "$grub_cfg" -e "$cfg_key=*"; then
        echo "$cfg_key=\"$cfg_value\"" >>"$grub_cfg"
    fi
    sed -i "s;${cfg_key}=.*;${cfg_key}=\"${cfg_value}\";g" "$grub_cfg"
    sudo sed -i "s/^#$cfg_key/$cfg_key/g" "$grub_cfg"

    sudo update-grub
}

remove() {
    return 0
}

update() {
    return 0
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
