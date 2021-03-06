#!/bin/bash

TWEAK_RES_DIR="$2" && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi
TWEAK_CACHE_DIR="$3" && if [ -z "$3" ]; then TWEAK_CACHE_DIR="$(pwd)"; fi

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

    if ! local whiptail_result=$(whiptail --menu --notags "NVIDIA GRAPHICS DRIVER" 0 0 5 "nvidia" "NVIDIA" "nouveau" "NVIDIA (nouveau)" "nvidia-frogging" "NVIDIA (frogging-family)" "nvidia-390xx" "NVIDIA 390xx" "nvidia-390xx-bumblebee" "Intel HD + NVIDIA 390xx (Bumblebee)" 3>&1 1>&2 2>&3); then
        exit 1
    fi

    if [ "$whiptail_result" = 'nvidia' ]; then

        # Install
        paru --noconfirm --needed --sudoloop -S nvidia-dkms nvidia-settings lib32-nvidia-utils opencl-nvidia lib32-opencl-nvidia virtualgl lib32-virtualgl mesa

        # Early Loading
        sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g" "/etc/mkinitcpio.conf"

        # DRM kernel mode setting (nvidia-drm.modeset=1)
        sudo sed -i "s/quiet splash/nvidia-drm.modeset=1 quiet splash/g" "/boot/loader/entries/ecos.conf"

        # Rebuild
        sudo mkinitcpio -P

        # Create xorg settings
        sudo nvidia-xconfig

        exit 0
    fi

    if [ "$whiptail_result" = 'nouveau' ]; then
        paru --noconfirm --needed --sudoloop -S mesa lib32-mesa xf86-video-nouveau
        sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 nouveau)/g" "/etc/mkinitcpio.conf"
        sudo mkinitcpio -P
        exit 0
    fi

    if [ "$whiptail_result" = 'nvidia-frogging' ]; then

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
        sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g" "/etc/mkinitcpio.conf"

        # DRM kernel mode setting (nvidia-drm.modeset=1)
        sudo sed -i "s/quiet splash/nvidia-drm.modeset=1 quiet splash/g" "/boot/loader/entries/ecos.conf"

        # Rebuild
        sudo mkinitcpio -P

        # Create xorg settings
        sudo nvidia-xconfig

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
        sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g" "/etc/mkinitcpio.conf"

        # DRM kernel mode setting (nvidia-drm.modeset=1)
        sudo sed -i "s/quiet splash/nvidia-drm.modeset=1 quiet splash/g" "/boot/loader/entries/ecos.conf"

        # Rebuild
        sudo mkinitcpio -P

        # Create xorg settings
        sudo nvidia-xconfig

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

        # Intel Driver
        echo 'COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer' | sudo tee -a "/etc/environment" # Font and screen corruption in GTK applications (missing glyphs after suspend/resume)
        local conf='
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "DRI" "3"
    #Option      "AccelMethod" "uxa"
    #Option      "TearFree" "true" # Will not work with AccelMethod=uxa
EndSection'
        echo "$conf" | sudo tee -a "/etc/X11/xorg.conf.d/20-intel.conf"

        # Early Loading
        sudo sed -i "s/MODULES=(ext4)/MODULES=(ext4 intel_agp i915)/g" "/etc/mkinitcpio.conf"

        # Rebuild
        sudo mkinitcpio -P

        exit 0
    fi
}

remove() {

    # NVIDIA
    paru --noconfirm --sudoloop -Rsn nvidia nvidia-settings lib32-nvidia-utils

    # NVIDIA Frogging
    paru --noconfirm --sudoloop -Rsn lib32-nvidia-utils-tkg lib32-opencl-nvidia-tkg nvidia-dkms-tkg nvidia-egl-wayland-tkg nvidia-settings-tkg nvidia-utils-tkg opencl-nvidia-tkg
    paru --noconfirm --sudoloop -Rsn lib32-nvidia-dev-utils-tkg lib32-opencl-nvidia-dev-tkg nvidia-dev-dkms-tkg nvidia-dev-egl-wayland-tkg nvidia-dev-settings-tkg nvidia-dev-utils-tkg opencl-nvidia-dev-tkg

    # optional: opencl-nvidia-390xx lib32-opencl-nvidia-390xx lib32-virtualgl
    paru --noconfirm --sudoloop -Rsn nvidia-390xx-dkms nvidia-390xx-settings nvidia-390xx-utils lib32-nvidia-390xx-utils opencl-nvidia-390xx lib32-opencl-nvidia-390xx lib32-virtualgl
    paru --noconfirm --sudoloop -Rsn xf86-video-nouveau

    sudo sed -i "s/MODULES=(ext4 intel_agp i915)/MODULES=(ext4)/g" "/etc/mkinitcpio.conf"
    sudo sed -i "s/MODULES=(ext4 nouveau)/MODULES=(ext4)/g" "/etc/mkinitcpio.conf"
    sudo sed -i "s/MODULES=(ext4 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/MODULES=(ext4)/g" "/etc/mkinitcpio.conf"

    sudo sed -i "s/nvidia-drm.modeset=1 quiet splash/quiet splash/g" "/boot/loader/entries/ecos.conf"

    sudo rm -f "/etc/X11/xorg.conf.d/20-intel.conf"
    sudo sed -i '/COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer/d' "/etc/environment"

    sudo rm -f /etc/X11/xorg.conf.d/30-nvidia-ignoreabi.conf

    # Bumblebee
    sudo systemctl disable bumblebeed.service
    paru --noconfirm --sudoloop -Rsn bumblebee xf86-video-intel primus lib32-primus

    # Nvidia Only
    sudo rm -f /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
    sudo rm -f /usr/share/gdm/greeter/autostart/optimus.desktop
    sudo rm -f /etc/xdg/autostart/optimus.desktop

    # Rebuild
    sudo mkinitcpio -P

}

update() {
    return 0
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
