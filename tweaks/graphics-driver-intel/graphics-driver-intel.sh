#!/bin/bash
# https://wiki.archlinux.org/title/Intel_graphics

# BUG (xf86-video-intel): After scrensafer the screen still be black https://wiki.archlinux.org/title/intel_graphics#DRI3_issues

install() {

    if ! local whiptail_result=$(whiptail --menu --notags "INTEL GRAPHICS DRIVER" 0 0 2 "intel-i915" "Mesa Driver (intel-i915)" "xf86-video-intel" "Intel Driver (xf86-video-intel)" 3>&1 1>&2 2>&3); then
        exit 0
    fi

    if [ "$whiptail_result" = 'intel-i915' ]; then
        paru --noconfirm --needed --sudoloop -S mesa vulkan-intel vulkan-tools
        paru --noconfirm --needed --sudoloop -S lib32-mesa lib32-vulkan-intel
        sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 intel_agp i915)/g" "/etc/mkinitcpio.conf"
        sudo mkinitcpio -P
        exit 0
    fi

    if [ "$whiptail_result" = 'xf86-video-intel' ]; then
        paru --noconfirm --needed --sudoloop -S xf86-video-intel
        paru --noconfirm --needed --sudoloop -S mesa vulkan-intel vulkan-tools
        paru --noconfirm --needed --sudoloop -S lib32-mesa lib32-vulkan-intel
        sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 intel_agp i915)/g" "/etc/mkinitcpio.conf"
        sudo mkinitcpio -P

        # Font and screen corruption in GTK applications (missing glyphs after suspend/resume)
        echo 'COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer' | sudo tee -a "/etc/environment"
        local conf='
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "DRI" "3"
    #Option      "AccelMethod" "uxa"
    #Option      "TearFree" "true" # Will not work with AccelMethod=uxa
EndSection'
        echo "$conf" | sudo tee -a "/etc/X11/xorg.conf.d/20-intel.conf"
        exit 0
    fi
}

remove() {
    paru --noconfirm --sudoloop -R xf86-video-intel
    paru --noconfirm --sudoloop -R vulkan-intel vulkan-tools lib32-vulkan-intel
    sudo sed -i "s/MODULES=(ext4 intel_agp i915)/MODULES=(ext4)/g" "/etc/mkinitcpio.conf"
    sudo sed -i '/COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer/d' "/etc/environment"
    sudo rm -f "/etc/X11/xorg.conf.d/20-intel.conf"
    sudo mkinitcpio -P
}

update() {
    return 0
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
