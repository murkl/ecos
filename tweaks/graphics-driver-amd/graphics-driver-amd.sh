#!/bin/bash

install() {
    paru --noconfirm --needed --sudoloop -S xf86-video-amdgpu
    sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 amdgpu)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -P
}

remove() {
    paru --noconfirm --sudoloop -R xf86-video-amdgpu
    sudo sed -i "s/MODULES=(ext4 amdgpu)/MODULES=(ext4)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -P
}

update() {
    return 0
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
