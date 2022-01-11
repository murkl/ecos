#!/bin/bash

TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

# RESOURCES
# https://wiki.archlinux.org/title/NVIDIA
# https://wiki.archlinux.org/title/NVIDIA_Optimus

# SHOW GRAPHIC CARD INFO:
# lspci -k | grep -A 2 -E "(VGA|3D)"

# TEST NVIDIA
# glxinfo | grep NVIDIA
# glxgears

# NVIDIA BUMBLEBEE
# optirun -b primus <APP>

# TEST NVIDIA BUMBLEBEE
# optirun -b primus glxgears -info
# optirun -b primus glxspheres64
# optirun -b primus glxspheres32

install() {

    if ! local whiptail_result=$(whiptail --menu --notags "NVIDIA GRAPHICS DRIVER" 0 0 4 "nouveau" "NVIDIA (nouveau)" "nvidia" "NVIDIA (nvidia)" "nvidia-390xx" "NVIDIA 390xx" "nvidia-390xx-bumblebee" "Intel HD + NVIDIA 390xx (Bumblebee)" 3>&1 1>&2 2>&3); then
        exit 1
    fi

    if [ "$whiptail_result" = 'nouveau' ]; then
        paru --noconfirm --needed --sudoloop -S mesa lib32-mesa xf86-video-nouveau
        sudo sed -i "s/MODULES=()/MODULES=(nouveau)/g" "/etc/mkinitcpio.conf"
        sudo mkinitcpio -P
        exit 0
    fi

    if [ "$whiptail_result" = 'nvidia' ]; then

        # https://www.reddit.com/r/linux_gaming/comments/rtsxey/pacman_install_nvidia_driver_470/
        # https://github.com/frogging-family/nvidia-all

        rm -rf "$TWEAK_CACHE_DIR/repo"
        git clone "https://github.com/frogging-family/nvidia-all" "$TWEAK_CACHE_DIR/repo"
        cd "$TWEAK_CACHE_DIR/repo" || exit 1
        sed -i 's/dkms=""/dkms="true"/g' customization.cfg
        if ! makepkg -si; then
            echo "Error makepkg"
            exit 1
        fi

        # Early Loading
        sudo sed -i "s/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g" "/etc/mkinitcpio.conf"

        # DRM kernel mode setting (nvidia-drm.modeset=1)
        sudo sed -i "s/vt.global_cursor_default=0 rw/vt.global_cursor_default=0 nvidia-drm.modeset=1 rw/g" "/boot/loader/entries/arch.conf"

        # Rebuild
        sudo mkinitcpio -P

        exit 0
    fi

    if [ "$whiptail_result" = "nvidia-390xx" ]; then
        # NVDIA Driver Only (https://wiki.archlinux.org/title/NVIDIA_Optimus#Use_NVIDIA_graphics_only)

        # Install Dependencies
        paru --noconfirm --needed --sudoloop -S linux-headers xorg-xrandr mesa mesa-demos

        # Install NVIDIA Driver
        # optional: opencl-nvidia-390xx
        paru --noconfirm --needed --sudoloop -S nvidia-390xx-dkms nvidia-390xx-settings opencl-nvidia-390xx

        # 32 Bit Support
        # optional: lib32-opencl-nvidia-390xx lib32-virtualgl
        paru --noconfirm --needed --sudoloop -S lib32-nvidia-390xx-utils lib32-opencl-nvidia-390xx lib32-virtualgl

        # Early Loading
        sudo sed -i "s/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g" "/etc/mkinitcpio.conf"

        # DRM kernel mode setting (nvidia-drm.modeset=1)
        sudo sed -i "s/vt.global_cursor_default=0 rw/vt.global_cursor_default=0 nvidia-drm.modeset=1 rw/g" "/boot/loader/entries/arch.conf"

        # Rebuild
        sudo mkinitcpio -P

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
        exit 0
    fi

    if [ "$whiptail_result" = "nvidia-390xx-bumblebee" ]; then

        # Install Dependencies
        paru --noconfirm --needed --sudoloop -S linux-headers xorg-xrandr mesa mesa-demos

        # Install NVIDIA Driver
        # optional: opencl-nvidia-390xx
        paru --noconfirm --needed --sudoloop -S nvidia-390xx-dkms nvidia-390xx-settings opencl-nvidia-390xx

        # 32 Bit Support
        # optional: lib32-opencl-nvidia-390xx lib32-virtualgl
        paru --noconfirm --needed --sudoloop -S lib32-nvidia-390xx-utils lib32-opencl-nvidia-390xx lib32-virtualgl

        # optional: lib32-virtualgl
        paru --noconfirm --needed --sudoloop -S mesa bumblebee xf86-video-intel lib32-virtualgl primus lib32-primus
        sudo gpasswd -a $USER bumblebee

        # Workaround for: [ERROR]Cannot access secondary GPU - error: [XORG] (EE) No devices detected.
        sudo sed -i 's/#   BusID "PCI:01:00:0"/    BusID "PCI:01:00:0"/g' "/etc/bumblebee/xorg.conf.nvidia"

        sudo systemctl enable bumblebeed.service

        # Early Loading
        sudo sed -i "s/MODULES=()/MODULES=(i915)/g" "/etc/mkinitcpio.conf"

        # Rebuild
        sudo mkinitcpio -P

        exit 0
    fi
}

remove() {
    paru --noconfirm --sudoloop -Rsn lib32-nvidia-utils-tkg lib32-opencl-nvidia-tkg nvidia-dkms-tkg nvidia-egl-wayland-tkg nvidia-settings-tkg nvidia-utils-tkg opencl-nvidia-tkg

    # optional: opencl-nvidia-390xx lib32-opencl-nvidia-390xx lib32-virtualgl
    paru --noconfirm --sudoloop -Rsn nvidia-390xx-dkms nvidia-390xx-settings nvidia-390xx-utils lib32-nvidia-390xx-utils opencl-nvidia-390xx lib32-opencl-nvidia-390xx lib32-virtualgl
    paru --noconfirm --sudoloop -Rsn xf86-video-nouveau

    sudo sed -i "s/MODULES=(i915)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo sed -i "s/MODULES=(nouveau)/MODULES=()/g" "/etc/mkinitcpio.conf"
    sudo sed -i "s/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/MODULES=()/g" "/etc/mkinitcpio.conf"

    sudo sed -i "s/vt.global_cursor_default=0 nvidia-drm.modeset=1 rw/vt.global_cursor_default=0 rw/g" "/boot/loader/entries/arch.conf"
    sudo mkinitcpio -P

    sudo rm -f /etc/X11/xorg.conf.d/30-nvidia-ignoreabi.conf

    # Bumblebee
    sudo systemctl disable bumblebeed.service
    paru --noconfirm --sudoloop -Rsn bumblebee xf86-video-intel primus lib32-primus

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
