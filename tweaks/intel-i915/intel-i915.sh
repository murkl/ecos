#!/bin/bash

install() {
    paru --needed --sudoloop -Syyu mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-tools
    sudo sed -i "s/MODULES=()/MODULES=(i915)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

remove() {
    paru --sudoloop -Rsnvulkan-intel lib32-vulkan-intel vulkan-tools
    sudo sed -i "s/MODULES=(i915)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

update() {
    echo "Nohting to do..."
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
