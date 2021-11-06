#!/bin/bash
APPS='xf86-video-amdgpu'

install() {

    # Installing packages
    if ! paru --noconfirm --needed --sudoloop -Syyu mesa $APPS; then
        echo "Error installing $APPS"
        return 1
    fi

    # Modify /etc/mkinitcpio.conf
    local mkinit_conf='/etc/mkinitcpio.conf'
    sudo cp "$mkinit_conf" "$mkinit_conf".bak
    if ! sudo sed -i "s/MODULES=()/MODULES=(amdgpu)/g" "$mkinit_conf"; then
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
