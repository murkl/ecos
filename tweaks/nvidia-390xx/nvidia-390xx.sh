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
    sudo pacman -Rsn xf86-video-nouveau prime
    sudo cp "/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf.bak"
    sudo sed -i "s/MODULES=(nouveau)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux

    # Install Dependencies
    paru -S linux-headers xorg-xrandr mesa-demos

    # Install NVIDIA Driver
    paru -S nvidia-390xx-dkms nvidia-390xx-settings

    # 32 Bit Support
    paru -S lib32-nvidia-390xx-utils lib32-virtualgl

    # Add Kernel parameter (nvidia-drm.modeset=1)
    sudo cp "/boot/loader/entries/arch.conf " "/boot/loader/entries/arch.conf.bak"
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
    sudo pacman -Rsn nvidia-390xx-dkms nvidia-390xx-settings lib32-nvidia-390xx-utils lib32-virtualgl
    sudo rm -f /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
    sudo rm -f /etc/X11/xorg.conf.d/30-nvidia-ignoreabi.conf
    sudo rm -f /usr/share/gdm/greeter/autostart/optimus.desktop
    sudo rm -f /etc/xdg/autostart/optimus.desktop

    sudo sed -i "s/MODULES=(vt.global_cursor_default=0 nvidia-drm.modeset=1 rw)/MODULES=(vt.global_cursor_default=0 rw)/g" "/etc/mkinitcpio.conf"
    sudo mkinitcpio -p linux
}

update() {
    echo "Nothing to do..."
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
