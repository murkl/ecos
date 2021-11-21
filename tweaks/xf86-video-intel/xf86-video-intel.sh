#!/bin/bash
# https://wiki.archlinux.org/title/Intel_graphics

##################################################
# Intel + Vulkan Driver
##################################################

# sudo vim /etc/X11/xorg.conf.d/20-intel.conf

# Section "Device"
#    Identifier  "Intel Graphics"
#    Driver      "intel"
#    Option      "DRI" "3"
#    Option      "AccelMethod" "uxa"
#    #Option      "TearFree" "true" # Will not work with AccelMethod=uxa
# EndSection

install() {
    paru --noconfirm --needed --sudoloop -S xf86-video-intel mesa vulkan-intel vulkan-tools
    paru --noconfirm --needed --sudoloop -S lib32-mesa lib32-vulkan-intel
    sudo sed -i "s/MODULES=()/MODULES=(intel_agp i915)/g" "/etc/mkinitcpio.conf"
    echo 'COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer' | sudo tee -a "/etc/environment"
    sudo mkinitcpio -p linux
}

remove() {
    paru --noconfirm --sudoloop -R xf86-video-intel vulkan-intel vulkan-tools lib32-vulkan-intel
    sudo sed -i "s/MODULES=(intel_agp i915)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo sed -i '/COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer/d' "/etc/environment"
    sudo mkinitcpio -p linux
}

update() {
    echo "Nohting to do..."
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
