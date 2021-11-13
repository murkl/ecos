#!/bin/bash

install() {
    paru --noconfirm --needed --sudoloop -S mesa vulkan-intel vulkan-tools
    paru --noconfirm --needed --sudoloop -S lib32-mesa lib32-vulkan-intel
    sudo sed -i "s/MODULES=()/MODULES=(i915)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

remove() {
    paru --noconfirm --sudoloop -R vulkan-intel vulkan-tools lib32-mesa lib32-vulkan-intel
    sudo sed -i "s/MODULES=(i915)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

update() {
    echo "Nohting to do..."
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
