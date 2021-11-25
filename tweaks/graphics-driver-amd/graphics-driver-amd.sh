#!/bin/bash

install() {
    paru --noconfirm --needed --sudoloop -S xf86-video-amdgpu
    sudo sed -i "s/MODULES=()/MODULES=(amdgpu)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

remove() {
    paru --noconfirm --sudoloop -R xf86-video-amdgpu
    sudo sed -i "s/MODULES=(amdgpu)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

update() {
    echo "Nohting to do..."
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
