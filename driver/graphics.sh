#!/bin/bash
TITLE="Graphics Driver"

MENU_ITEMS=()
MENU_ITEMS+=("Intel Graphics Driver")
MENU_ITEMS+=("NVIDIA Graphics Driver")
MENU_ITEMS+=("AMD Graphics Driver")

main() {
    if ! ZENITY_RESULT="$(ecos --api menu "$TITLE" "${MENU_ITEMS[@]}")"; then
        exit 0
    fi

    if ! ROOT_PASSWORD="$(ecos --api root)"; then
        exit 0
    fi

    if ! ecos --api check-root; then
        ecos --api notify "Root Password wrong!"
        exit 1
    fi

    sh -c "echo $root_password | sudo -S cp /tmp/$SCRIPT_ID.systemd $SYSTEMD_SERVICE_FILE"

    if [ "$ZENITY_RESULT" = "Intel Graphics Driver" ]; then
        ecos --api notify "$ROOT_PASSWORD"
        exit 0
    fi

    if [ "$ZENITY_RESULT" = "NVIDIA Graphics Driver" ]; then
        exit 0
    fi

    if [ "$ZENITY_RESULT" = "AMD Graphics Driver" ]; then
        exit 0
    fi
}

main "$@"
