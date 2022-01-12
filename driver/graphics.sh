#!/bin/bash
TITLE="Graphics Driver"

MENU_ITEMS=()
MENU_ITEMS+=("Intel Graphics Driver")
MENU_ITEMS+=("NVIDIA Graphics Driver")
MENU_ITEMS+=("AMD Graphics Driver")

main() {

    local ZENITY_RESULT=''
    if ! ZENITY_RESULT="$(ecos --api menu "$TITLE" "${MENU_ITEMS[@]}")"; then
        exit 0
    fi

    local ROOT_PASSWORD=''
    if ! local ROOT_PASSWORD="$(ecos --api root)"; then
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

    ROOT_PASSWORD=''
}

main "$@"
