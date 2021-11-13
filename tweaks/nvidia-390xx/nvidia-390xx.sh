#!/bin/bash

# https://wiki.archlinux.org/title/NVIDIA
# https://wiki.archlinux.org/title/NVIDIA_Optimus

# List Drivers:
# lspci -k | grep -A 2 -E "(VGA|3D)"

# Test NVIDIA
# glxinfo | grep NVIDIA
# glxgears

install() {

    # Remove Nouveau Driver
    paru --noconfirm --sudoloop -R xf86-video-nouveau prime
    sudo cp -f "/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf.bak.nvidia-390xx"
    sudo sed -i "s/MODULES=(nouveau)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux

    # Install Dependencies
    paru --noconfirm --needed --sudoloop -S linux-headers xorg-xrandr mesa-demos

    # Install NVIDIA Driver
    paru --noconfirm --needed --sudoloop -S nvidia-390xx-dkms opencl-nvidia-390xx nvidia-390xx-settings

    # 32 Bit Support
    paru --noconfirm --needed --sudoloop -S lib32-nvidia-390xx-utils lib32-opencl-nvidia-390xx lib32-virtualgl

    # Add Kernel parameter (nvidia-drm.modeset=1)
    sudo cp -f "/boot/loader/entries/arch.conf" "/boot/loader/entries/arch.conf.bak.nvidia-390xx"
    sudo sed -i "s/MODULES=(vt.global_cursor_default=0 rw)/MODULES=(vt.global_cursor_default=0 nvidia-drm.modeset=1 rw)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux

    # Set NVDIA Driver (https://wiki.archlinux.org/title/NVIDIA_Optimus#Use_NVIDIA_graphics_only)
    echo '
Section "OutputClass"
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
EndSection
' >/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf

    # Set for GNOME GDM
    local nvidia_desktop_file_content='
[Desktop Entry]
Type=Application
Name=Optimus
Exec=sh -c "xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto"
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer'

    echo "$nvidia_desktop_file_content" >/usr/share/gdm/greeter/autostart/optimus.desktop
    echo "$nvidia_desktop_file_content" >/etc/xdg/autostart/optimus.desktop
}

remove() {
    paru --noconfirm --sudoloop -R nvidia-390xx-dkms opencl-nvidia-390xx nvidia-390xx-settings lib32-nvidia-390xx-utils lib32-opencl-nvidia-390xx lib32-virtualgl

    sudo rm -f /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
    sudo rm -f /etc/X11/xorg.conf.d/30-nvidia-ignoreabi.conf
    sudo rm -f /usr/share/gdm/greeter/autostart/optimus.desktop
    sudo rm -f /etc/xdg/autostart/optimus.desktop

    sudo mv -f "/etc/mkinitcpio.conf.bak.nvidia-390xx" "/etc/mkinitcpio.conf"
    sudo mv -f "/boot/loader/entries/arch.conf.bak.nvidia-390xx" "/boot/loader/entries/arch.conf"

    sudo mkinitcpio -p linux
}

update() {
    echo "Nothing to do..."
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
