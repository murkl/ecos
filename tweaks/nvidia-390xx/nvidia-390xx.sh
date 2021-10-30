#!/bin/bash
TWEAK_RES="$2"

install() {

    if [ -f /etc/X11/xorg.conf ]; then
        sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
    fi

    # Remove conflict packages
    if pacman -Qi xf86-video-nouveau >/dev/null; then
        paru --noconfirm --sudoloop -Rs xf86-video-nouveau
    fi
    if pacman -Qi plymouth >/dev/null; then
        paru --noconfirm --sudoloop -Rs plymouth
    fi

    # Install packages
    #local nvidia_apps='mesa nvidia-390xx nvidia-390xx-dkms nvidia-390xx-settings opencl-nvidia-390xx lib32-opencl-nvidia-390xx lib32-nvidia-390xx-utils bumblebee bbswitch primus lib32-virtualgl'
    local nvidia_apps='mesa mesa-demos bumblebee nvidia-390xx lib32-virtualgl opencl-nvidia-390xx lib32-nvidia-390xx-utils lib32-opencl-nvidia-390xx'
    if ! paru --noconfirm --needed --sudoloop -Syyu $nvidia_apps; then
        echo "Error installing $nvidia_apps"
        return 1
    fi

    # Add user to bumblebee group
    sudo gpasswd -a $USER bumblebee

    # Start bumblebee service
    sudo systemctl enable bumblebeed.service
}

remove() {
    echo "remove"
}

update() {
    echo "update"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
