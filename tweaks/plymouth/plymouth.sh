#!/bin/bash
TWEAK_RES_URL="$2"

install() {

    if ! efivar -l >/dev/null; then
        echo "BIOS detected. Plymouth only available on UEFI!"
        return 1
    fi

    # Check if installed
    if pacman -Qi plymouth >/dev/null; then
        echo "Plymouth already installed!"
        return 1
    fi

    #----------------------------------------
    # Install Plymouth
    #----------------------------------------
    echo 'INSTALL PLYMOUTH'
    wait
    if ! paru --noconfirm --needed --sudoloop -Syyu plymouth; then
        echo "ERROR paru"
        exit 1
    fi
    echo -e 'OK'

    #----------------------------------------
    # Configure mkinitcpio
    #----------------------------------------
    echo 'CONFIGURE MKINITCPIO'
    # Intel graphic support (other: https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start)
    local mkinit_conf='/etc/mkinitcpio.conf'
    sudo cp "$mkinit_conf" "$mkinit_conf".before-plymouth
    if ! sudo sed -i "s/keymap encrypt filesystems/keymap plymouth plymouth-encrypt filesystems/g" "$mkinit_conf"; then
        echo "ERROR"
        exit 1
    fi
    echo -e 'OK'

    #----------------------------------------
    # Configure Spinner
    #----------------------------------------
    echo 'CONFIGURE SPINNER'
    local spinner_conf='/usr/share/plymouth/themes/spinner/spinner.plymouth'
    sudo cp -f "$spinner_conf" "$spinner_conf".bak

    replace_spinner_conf_value() {
        #sed -i "s#$1=.*#$1=$2#g" "$spinner_conf"
        if ! sudo sed -i "s#$1=.*#$1=$2#g" "$spinner_conf"; then
            echo "ERROR"
            exit 1
        fi
    }

    replace_spinner_conf_value "DialogVerticalAlignment" ".680"
    replace_spinner_conf_value "TitleVerticalAlignment" ".680"
    replace_spinner_conf_value "BackgroundStartColor" "0x2E3440"
    replace_spinner_conf_value "BackgroundEndColor" "0x2E3440"

    echo -e 'OK'

    #----------------------------------------
    # Download Watermark
    #----------------------------------------
    echo 'DOWNLOAD WATERMARK'
    local watermark_file='/usr/share/plymouth/themes/spinner/watermark.png'
    sudo mv -f "$watermark_file" "$watermark_file".bak
    curl -L "$TWEAK_RES_URL/plymouth.png" -o /tmp/watermark.png
    sudo cp /tmp/watermark.png "$watermark_file"

    #----------------------------------------
    # Rebuild
    #----------------------------------------
    echo 'REBUILD'
    if ! sudo mkinitcpio -p linux; then
        # On error
        echo 'ERROR'
        echo "Error installing plymouth: rolling back..."
        sudo mv -f "$mkinit_conf".bak "$mkinit_conf"
        sudo mv -f "$spinner_conf".bak "$spinner_conf"
        sudo mv -f "$watermark_file".bak "$watermark_file"
        sudo mkinitcpio -p linux
    else
        echo 'PLYMOUTH SUCCESFUL INSTALLED'
        echo "Please Reboot..."
    fi
}

remove() {
    paru --noconfirm --sudoloop -Rs plymouth
}

update() {
    echo "Nothing to update"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
