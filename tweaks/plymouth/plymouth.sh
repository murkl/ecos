#!/bin/bash
TWEAK_RES_DIR="$2" && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi

MKINIT_CONF='/etc/mkinitcpio.conf'
SPINNER_CONF='/usr/share/plymouth/themes/spinner/spinner.plymouth'
WATERMARK_FILE='/usr/share/plymouth/themes/spinner/watermark.png'
SPINNER_CONF_BAK="$SPINNER_CONF.bak"
WATERMARK_FILE_BAK="$WATERMARK_FILE.bak"
PLYMOUTH_WATERMARK_PNG="$TWEAK_RES_DIR/plymouth.png"

install() {

    #----------------------------------------
    # Install Plymouth
    #----------------------------------------
    echo 'INSTALL PLYMOUTH'
    wait
    if ! paru --noconfirm --needed --sudoloop -S plymouth; then echo "ERROR paru" && exit 1; fi
    echo -e 'OK'

    #----------------------------------------
    # Configure mkinitcpio
    #----------------------------------------
    echo 'CONFIGURE MKINITCPIO'
    # Intel graphic support (other: https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start)
    if ! sudo sed -i "s/keymap sd-encrypt lvm2 filesystems/keymap sd-plymouth sd-encrypt lvm2 filesystems/g" "$MKINIT_CONF"; then echo "ERROR" && exit 1; fi
    echo -e 'OK'

    #----------------------------------------
    # Configure Spinner
    #----------------------------------------
    echo 'CONFIGURE SPINNER'
    # Backup spinner conf
    if [ ! -f "$SPINNER_CONF_BAK" ]; then sudo cp -f "$SPINNER_CONF" "$SPINNER_CONF_BAK"; fi
    replace_spinner_conf_value() {
        #sed -i "s#$1=.*#$1=$2#g" "$SPINNER_CONF"
        if ! sudo sed -i "s#$1=.*#$1=$2#g" "$SPINNER_CONF"; then echo "ERROR" && exit 1; fi
    }
    replace_spinner_conf_value "DialogVerticalAlignment" ".680"
    replace_spinner_conf_value "TitleVerticalAlignment" ".680"
    replace_spinner_conf_value "BackgroundStartColor" "0x2E3440"
    replace_spinner_conf_value "BackgroundEndColor" "0x2E3440"
    echo -e 'OK'

    #----------------------------------------
    # Copy Watermark
    #----------------------------------------
    echo 'COPY WATERMARK PNG FILE'
    # Backup watermark file
    if [ ! -f "$WATERMARK_FILE_BAK" ] && [ -f "$WATERMARK_FILE" ]; then sudo cp -f "$WATERMARK_FILE" "$WATERMARK_FILE_BAK"; fi
    sudo cp -f "$PLYMOUTH_WATERMARK_PNG" "$WATERMARK_FILE"

    #----------------------------------------
    # Rebuild
    #----------------------------------------
    echo 'REBUILD'
    if ! sudo mkinitcpio -P; then
        echo "ERROR: Installing Plymouth -> rolling back..."
        remove
    else
        echo 'PLYMOUTH SUCCESFUL INSTALLED'
        echo "Please Reboot..."
    fi
}

remove() {
    paru --noconfirm --sudoloop -R plymouth
    sudo sed -i "s/keymap plymouth plymouth-encrypt lvm2 filesystems/keymap encrypt lvm2 filesystems/g" "$MKINIT_CONF"
    sudo mv -f "$SPINNER_CONF_BAK" "$SPINNER_CONF"
    sudo mv -f "$WATERMARK_FILE_BAK" "$WATERMARK_FILE"
    sudo rm -rf "/usr/share/plymouth/"
    sudo mkinitcpio -P
}

update() {
    return 0
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
