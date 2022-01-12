#!/bin/bash
TITLE="Graphics Driver"

MENU_ITEMS=()
MENU_ITEMS+=("intel-i915")
MENU_ITEMS+=("nvidia-all")
MENU_ITEMS+=("nvidia-390xx-bumblebee")

ROOT_PASSWORD=''

main() {

    source $(ecos --api config) || exit 1

    # CHECK PROPERTIES
    if [ -z "$TERMINAL_EXEC" ]; then ecos --api notify "TERMINAL_EXEC peroperty is missing!" && exit 1; fi

    local ZENITY_RESULT=''
    if ! ZENITY_RESULT="$(ecos --api menu "$TITLE" "${MENU_ITEMS[@]}")"; then
        exit 0
    fi

    ROOT_PASSWORD=''
    if ! ROOT_PASSWORD="$(ecos --api root)"; then
        exit 1
    fi

    if [ "$ROOT_PASSWORD" = "" ]; then
        ecos --api notify "Root Password empty!"
        exit 1
    fi

    if ! ecos --api check-root "$ROOT_PASSWORD"; then
        ecos --api notify "Root Password wrong!"
        exit 1
    fi

    if [ "$ZENITY_RESULT" = "intel-i915" ]; then
        intel_i915 "$@"
        exit 0
    fi

    if [ "$ZENITY_RESULT" = "nvidia-all" ]; then
        nvidia_all "$@"
        exit 0
    fi

    if [ "$ZENITY_RESULT" = "nvidia-390xx-bumblebee" ]; then
        nvidia_390xx_bumblebee "$@"
        exit 0
    fi

    ROOT_PASSWORD=''
}

intel_i915() {
    exit 1
}

nvidia_all() {
    # https://www.reddit.com/r/linux_gaming/comments/rtsxey/pacman_install_nvidia_driver_470/
    # https://github.com/frogging-family/nvidia-all
    (
        # Clone Repo
        local driver_repo_dir="."
        rm -rf "$driver_repo_dir/repo"
        git clone "https://github.com/frogging-family/nvidia-all" "$driver_repo_dir/repo"
        cd "$driver_repo_dir/repo" || exit 1
        sed -i 's/dkms=""/dkms="true"/g' customization.cfg

        # Make pkg
        ecos --api check-root "$ROOT_PASSWORD"
        echo -ne '3\n' | makepkg -si --noconfirm

        # Early Loading
        sh -c 'echo $root_password | sudo -S sed -i "s/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g" "/etc/mkinitcpio.conf"'

        # DRM kernel mode setting (nvidia-drm.modeset=1)
        sh -c 'echo $root_password | sudo -S sed -i "s/vt.global_cursor_default=0 rw/vt.global_cursor_default=0 nvidia-drm.modeset=1 rw/g" "/boot/loader/entries/arch.conf"'

        # Rebuild
        sh -c 'echo $root_password | sudo -S sed -i "sudo mkinitcpio -P"'
    ) &

    if ! ecos --api progress "Install NVIDIA Driver" "$!"; then exit 1; fi

    # Notify
    ecos --api notify "NVIDIA Driver sucessfully installed"
}

nvidia_390xx_bumblebee() {
    exit 1
}

main "$@"
