#!/bin/bash
##################################################
# Intel + Vulkan Driver
##################################################

# paru -S xf86-video-intel
# paru -S lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-tools
# sudo vim /etc/X11/xorg.conf.d/20-intel.conf

# Section "Device"
#    Identifier  "Intel Graphics"
#    Driver      "intel"
#    Option      "DRI"    "3"
# EndSection

APPS='xf86-video-intel lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-tools'

install() {

    # Installing packages
    if ! paru --noconfirm --needed --sudoloop -Syyu mesa $APPS; then
        echo "Error installing $APPS"
        return 1
    fi

    # Modify /etc/mkinitcpio.conf
    local mkinit_conf='/etc/mkinitcpio.conf'
    sudo cp "$mkinit_conf" "$mkinit_conf".bak
    if ! sudo sed -i "s/MODULES=()/MODULES=(i915)/g" "$mkinit_conf"; then
        echo "Error edit $mkinit_conf"
        return 1
    fi
    sudo mkinitcpio -p linux
}

remove() {
    paru --noconfirm --sudoloop -Rsn $APPS
}

update() {
    echo "Nohting to update"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
