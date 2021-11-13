#!/bin/bash

##################################################
# Intel + Vulkan Driver
##################################################

# sudo vim /etc/X11/xorg.conf.d/20-intel.conf

# Section "Device"
#    Identifier  "Intel Graphics"
#    Driver      "intel"
#    Option      "DRI"    "3"
# EndSection

install() {
    paru --needed --sudoloop -Syyu xf86-video-intel mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-tools
    sudo sed -i "s/MODULES=()/MODULES=(i915)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

remove() {
    paru --sudoloop -Rsn xf86-video-intel vulkan-intel lib32-vulkan-intel vulkan-tools
    sudo sed -i "s/MODULES=(i915)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

update() {
    echo "Nohting to do..."
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
