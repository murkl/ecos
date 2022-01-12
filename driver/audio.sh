#!/bin/bash
TITLE="Audio Driver"

MENU_ITEMS=()
MENU_ITEMS+=("None")

main() {
    if ! ZENITY_RESULT="$(ecos --api menu "$TITLE" "${MENU_ITEMS[@]}")"; then
        exit 0
    fi

    if [ "$ZENITY_RESULT" = "None" ]; then
        exit 0
    fi

}

main "$@"
