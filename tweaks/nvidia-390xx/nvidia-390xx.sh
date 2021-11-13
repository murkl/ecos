#!/bin/bash
# https://wiki.archlinux.org/title/NVIDIA
# https://wiki.archlinux.org/title/NVIDIA_Optimus
# https://wiki.archlinux.org/title/Bumblebee

# Remove Nouveau Driver
sudo pacman -Rsn xf86-video-nouveau prime
sudo cp "/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf.bak"
sudo sed -i "s/MODULES=(nouveau)/MODULES=()/g" "/etc/mkinitcpio.conf"
sudo mkinitcpio -p linux

# Install NVIDIA Driver
paru -S nvidia-390xx-dkms linux-headers xorg-xrandr
paru -S opencl-nvidia-390xx

# 32 Bit Support
paru -S lib32-nvidia-390xx-utils lib32-virtualgl lib32-opencl-nvidia-390xx

# Optional
paru -S nvidia-390xx-settings
paru -S mesa-demos

# Add Kernel parameter (nvidia-drm.modeset=1)
sudo cp "/boot/loader/entries/arch.conf " "/boot/loader/entries/arch.conf.bak"
sudo sed -i "s/MODULES=(vt.global_cursor_default=0 rw)/MODULES=(vt.global_cursor_default=0 nvidia-drm.modeset=1 rw)/g" "/etc/mkinitcpio.conf"
sudo mkinitcpio -p linux

# ///////////////////////////////////////////
# VARIANT 1: NVIDIA DRIVER ONLY
# ///////////////////////////////////////////

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
nvidia_desktop_file_content='
[Desktop Entry]
Type=Application
Name=Optimus
Exec=sh -c "xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto"
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer'

echo "$nvidia_desktop_file_content" >/usr/share/gdm/greeter/autostart/optimus.desktop
echo "$nvidia_desktop_file_content" >/etc/xdg/autostart/optimus.desktop

# ///////////////////////////////////////////
# VARIANT 2: NVIDIA DRIVER HYBRID (BUMBLEBEE)
# ///////////////////////////////////////////
sudo rm -f /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
sudo rm -f /usr/share/gdm/greeter/autostart/optimus.desktop
sudo rm -f /etc/xdg/autostart/optimus.desktop
paru -S bumblebee
sudo gpasswd -a $USER bumblebee
sudo systemctl enable bumblebeed.service

# paru -S mesa nvidia-390xx lib32-nvidia-390xx-utils bumblebee bbswitch primus lib32-virtualgl
# TWEAK_APPS='mesa-demos bumblebee nvidia-390xx nvidia-390xx-dkms lib32-virtualgl opencl-nvidia-390xx lib32-nvidia-390xx-utils lib32-opencl-nvidia-390xx'
# (optional): paru -S xf86-video-intel

# sudo gpasswd -a $USER bumblebee
# sudo systemctl enable bumblebeed.service

# Test
# glxinfo | grep NVIDIA
# optirun glxspheres64
# primusrun glxspheres64

TWEAK_APPS='nvidia-390xx-dkms lib32-nvidia-390xx-utils linux-headers xorg-xrandr'
#TWEAK_APPS='mesa-demos  nvidia-390xx-dkms lib32-nvidia-390xx-utils lib32-virtualgl opencl-nvidia-390xx lib32-opencl-nvidia-390xx'

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
    sudo systemctl disable bumblebeed.service
    paru --noconfirm --sudoloop -Rsn $TWEAK_APPS
}

update() {
    echo "Nothing to update"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
