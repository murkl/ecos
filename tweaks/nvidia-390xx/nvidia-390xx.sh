#!/bin/bash
TWEAK_APPS='mesa-demos bumblebee nvidia-390xx lib32-virtualgl opencl-nvidia-390xx lib32-nvidia-390xx-utils lib32-opencl-nvidia-390xx'

install() {

    if [ -f /etc/X11/xorg.conf ]; then
        sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
    fi

    # Remove conflict packages
    if pacman -Qi xf86-video-nouveau >/dev/null; then
        paru --noconfirm --sudoloop -Rs xf86-video-nouveau
    fi

    # Install packages
    # mesa nvidia-390xx nvidia-390xx-dkms nvidia-390xx-settings opencl-nvidia-390xx lib32-opencl-nvidia-390xx lib32-nvidia-390xx-utils bumblebee bbswitch primus lib32-virtualgl
    if ! paru --noconfirm --needed --sudoloop -Syyu mesa $TWEAK_APPS; then
        echo "Error installing $TWEAK_APPS"
        return 1
    fi

    # Add user to bumblebee group
    sudo gpasswd -a $USER bumblebee

    # Start bumblebee service
    sudo systemctl enable bumblebeed.service
}

remove() {
    paru --noconfirm --sudoloop -Rsn $TWEAK_APPS
}

update() {
    echo "Nothing to update"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
