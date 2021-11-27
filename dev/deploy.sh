#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"

# DEV FILE
SCRIPT_DEV="$SCRIPT_DIR/ecos-dev"
VERSION_DEV="$($SCRIPT_DEV --version)"

# RELEASE FILE
SCRIPT_RELEASE="$SCRIPT_DIR/../release/ecos"
VERSION_RELEASE="$($SCRIPT_RELEASE --version)"

# //////////////////////////////////
# INIT
# //////////////////////////////////

init() {
    echo -e "\n"
    echo -e "//////////////////////////"
    echo -e "> DEPLOY ECOS CORE"
    echo -e "//////////////////////////"
    echo -e "\n"
    echo -e "VERSION RELEASE:  $VERSION_RELEASE"
    echo -e "VERSION DEV:      $VERSION_DEV"
    echo -e "\n\n"
    read -p "DEPLOY ECOS $VERSION_DEV? [yes/no]: " user_input
    if [ "$user_input" = "yes" ]; then
        if ! cp -f "$SCRIPT_DEV" "$SCRIPT_RELEASE"; then
            echo -e "ERROR: cp -f "$SCRIPT_DEV" "$SCRIPT_RELEASE""
            exit 1
        fi
        cd './../release' || exit 1
        git add ./ecos && git commit -m "$(./ecos --version)"
        echo -e "ECOS succefully deployed!"
    else
        echo -e "Skipped..."
    fi
}

# //////////////////////////////////
# START
# //////////////////////////////////

init "$@"
