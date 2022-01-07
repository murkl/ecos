#!/bin/bash

# https://wiki.archlinux.org/title/NVIDIA
# https://wiki.archlinux.org/title/NVIDIA_Optimus

# List Drivers:
# lspci -k | grep -A 2 -E "(VGA|3D)"

# Test NVIDIA
# glxinfo | grep NVIDIA
# glxgears

# ----------------------------------------------------------

# NVIDIA Geforce GT 730
# Driver: 470.94

# https://www.reddit.com/r/linux_gaming/comments/rtsxey/pacman_install_nvidia_driver_470/
# https://github.com/frogging-family/nvidia-all

# git clone https://github.com/frogging-family/nvidia-all && cd nvidia-all
# sed -i 's/dkms=""/dkms="true"/g' customization.cfg
# makepkg -si

# DRM kernel mode setting
# sudo vim /boot/loader/entries/arch.conf
# nvidia-drm.modeset=1

# Early Loading
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
# sudo mkinitcpio -p linux

# ----------------------------------------------------------

install() {

    if ! local whiptail_result=$(whiptail --menu --notags "NVIDIA GRAPHICS DRIVER" 0 0 4 "nouveau" "NVIDIA (nouveau)" "nvidia" "NVIDIA (nvidia)" "nvidia-390xx" "NVIDIA 390xx" "nvidia-390xx-bumblebee" "NVIDIA 390xx + Bumblebee" 3>&1 1>&2 2>&3); then
        exit 0
    fi

    if [ "$whiptail_result" = 'nouveau' ]; then
        paru --noconfirm --needed --sudoloop -S mesa lib32-mesa xf86-video-nouveau
        sudo sed -i "s/MODULES=()/MODULES=(nouveau)/g" "/etc/mkinitcpio.conf"
        sudo mkinitcpio -p linux
        exit 1
    fi

    if [ "$whiptail_result" = 'nvidia' ]; then
        echo "Sorry not implemented!"
        exit 1
    fi

    if [ "$whiptail_result" = 'nvidia-390xx' ] || [ "$whiptail_result" = 'nvidia-390xx-bumblebee' ]; then

        local BUMBLEBEE_ENABLED="false"
        if [ "$whiptail_result" = "nvidia-390xx" ]; then BUMBLEBEE_ENABLED="false"; fi
        if [ "$whiptail_result" = "nvidia-390xx-bumblebee" ]; then BUMBLEBEE_ENABLED="true"; fi

        # Remove Nouveau Driver
        paru --noconfirm --sudoloop -R xf86-video-nouveau prime
        sudo cp -f "/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf.bak.nvidia-390xx"
        sudo sed -i "s/MODULES=(nouveau)/MODULES=()/g" "/etc/mkinitcpio.conf"

        # Install Dependencies
        paru --noconfirm --needed --sudoloop -S linux-headers xorg-xrandr mesa mesa-demos

        # Install NVIDIA Driver
        # opencl-nvidia-390xx
        paru --noconfirm --needed --sudoloop -S nvidia-390xx-dkms nvidia-390xx-settings

        # 32 Bit Support
        # lib32-opencl-nvidia-390xx lib32-virtualgl
        paru --noconfirm --needed --sudoloop -S lib32-nvidia-390xx-utils

        # Add Kernel parameter (nvidia-drm.modeset=1)
        sudo cp -f "/boot/loader/entries/arch.conf" "/boot/loader/entries/arch.conf.bak.nvidia-390xx"
        sudo sed -i "s/vt.global_cursor_default=0 rw/vt.global_cursor_default=0 nvidia-drm.modeset=1 rw/g" "/boot/loader/entries/arch.conf"
        sudo mkinitcpio -p linux

        if [ "$BUMBLEBEE_ENABLED" = "true" ]; then
            paru --noconfirm --needed --sudoloop -S bumblebee xf86-video-intel
            #paru --noconfirm --needed --sudoloop -S lib32-virtualgl
            sudo gpasswd -a $USER bumblebee
            sudo systemctl enable bumblebeed.service
        else
            # NVDIA Driver Only (https://wiki.archlinux.org/title/NVIDIA_Optimus#Use_NVIDIA_graphics_only)
            echo 'Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection' >/tmp/10-nvidia-drm-outputclass.conf
            sudo cp -f /tmp/10-nvidia-drm-outputclass.conf /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf

            # Set for GNOME GDM
            echo '[Desktop Entry]
Type=Application
Name=Optimus
Exec=sh -c "xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto"
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer' >/tmp/optimus.desktop
            sudo cp -f /tmp/optimus.desktop /usr/share/gdm/greeter/autostart/optimus.desktop
            sudo cp -f /tmp/optimus.desktop /etc/xdg/autostart/optimus.desktop
        fi
    fi
}

remove() {
    # opencl-nvidia-390xx lib32-opencl-nvidia-390xx lib32-virtualgl
    paru --noconfirm --sudoloop -Rsn nvidia-390xx-dkms nvidia-390xx-settings nvidia-390xx-utils lib32-nvidia-390xx-utils
    paru --noconfirm --sudoloop -Rsn xf86-video-nouveau

    sudo sed -i "s/MODULES=(nouveau)/MODULES=()/g" "/etc/mkinitcpio.conf"

    sudo sed -i "s/vt.global_cursor_default=0 nvidia-drm.modeset=1 rw/vt.global_cursor_default=0 rw/g" "/boot/loader/entries/arch.conf"
    sudo mkinitcpio -p linux

    sudo rm -f /etc/X11/xorg.conf.d/30-nvidia-ignoreabi.conf

    # Bumblebee
    sudo systemctl disable bumblebeed.service
    paru --noconfirm --sudoloop -Rsn bumblebee xf86-video-intel

    # Nvidia Only
    sudo rm -f /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
    sudo rm -f /usr/share/gdm/greeter/autostart/optimus.desktop
    sudo rm -f /etc/xdg/autostart/optimus.desktop
}

update() {
    return 0
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
