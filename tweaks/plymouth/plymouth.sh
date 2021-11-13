#!/bin/bash
TWEAK_RES_DIR="$2"

MKINIT_CONF='/etc/mkinitcpio.conf'
MKINIT_CONF_BAK="$MKINIT_CONF.bak.before-plymouth"

SPINNER_CONF='/usr/share/plymouth/themes/spinner/spinner.plymouth'
SPINNER_CONF_BAK="$SPINNER_CONF.bak"

WATERMARK_FILE='/usr/share/plymouth/themes/spinner/watermark.png'
WATERMARK_FILE_BAK="$WATERMARK_FILE.bak"

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
        remove
        exit 1
    fi
    echo -e 'OK'

    #----------------------------------------
    # Configure mkinitcpio
    #----------------------------------------
    echo 'CONFIGURE MKINITCPIO'
    # Intel graphic support (other: https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start)
    sudo cp -f "$MKINIT_CONF" "$MKINIT_CONF_BAK"
    if ! sudo sed -i "s/keymap encrypt filesystems/keymap plymouth plymouth-encrypt filesystems/g" "$MKINIT_CONF"; then
        echo "ERROR"
        remove
        exit 1
    fi
    echo -e 'OK'

    #----------------------------------------
    # Configure Spinner
    #----------------------------------------
    echo 'CONFIGURE SPINNER'
    sudo cp -f "$SPINNER_CONF" "$SPINNER_CONF_BAK"

    replace_spinner_conf_value() {
        #sed -i "s#$1=.*#$1=$2#g" "$SPINNER_CONF"
        if ! sudo sed -i "s#$1=.*#$1=$2#g" "$SPINNER_CONF"; then
            echo "ERROR"
            remove
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
    sudo mv -f "$WATERMARK_FILE" "$WATERMARK_FILE_BAK"
    sudo cp -f "$TWEAK_RES_DIR/plymouth.png" "$WATERMARK_FILE"

    #----------------------------------------
    # Rebuild
    #----------------------------------------
    echo 'REBUILD'
    if ! sudo mkinitcpio -p linux; then
        # On error
        echo 'ERROR'
        echo "Error installing plymouth: rolling back..."
        remove
    else
        echo 'PLYMOUTH SUCCESFUL INSTALLED'
        echo "Please Reboot..."
    fi
}

remove() {
    paru --noconfirm --sudoloop -R plymouth
    sudo sed -i "s/keymap plymouth plymouth-encrypt filesystems/keymap encrypt filesystems/g" "$MKINIT_CONF"
    sudo mv -f "$SPINNER_CONF".bak "$SPINNER_CONF"
    sudo mv -f "$WATERMARK_FILE".bak "$WATERMARK_FILE"
    sudo mkinitcpio -p linux
}

update() {
    echo "Nothing to update"
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
