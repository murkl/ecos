#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"

# DEV FILE
SCRIPT_DEV="$SCRIPT_DIR/ecos"
VERSION_DEV="$($SCRIPT_DEV --version)"

# RELEASE FILE
SCRIPT_RELEASE="$SCRIPT_DIR/release/ecos"
VERSION_RELEASE="$($SCRIPT_RELEASE --version)"

# //////////////////////////////////
# INIT
# //////////////////////////////////

init() {
    echo -e "////////////////////////"
    echo -e "> ECOS CORE DEVELOPMENT"
    echo -e "////////////////////////"
    echo -e "\n"
    echo -e "VERSION DEV:      $VERSION_DEV"
    echo -e "VERSION RELEASE:  $VERSION_RELEASE"
    echo -e "\n"
    read -p "DEPLOY ECOS $VERSION_DEV? [yes/no]: " user_input
    if [ "$user_input" = "yes" ]; then

        # Check diff version
        if [ "$VERSION_DEV" = "$VERSION_RELEASE" ]; then
            echo -e "\n!! SAME VERSION !!\n"
            read -p "CONTINUE? [y/n]: " user_input
            if [ "$user_input" != "y" ]; then
                echo -e "Skipped..."
                exit 0
            fi
        fi

        # Copy dev to release
        if ! cp -f "$SCRIPT_DEV" "$SCRIPT_RELEASE"; then
            echo -e "ERROR: cp -f "$SCRIPT_DEV" "$SCRIPT_RELEASE""
            exit 1
        fi

        # Git commit
        cd "$SCRIPT_DIR" || exit 1
        git add "./release/ecos" && git commit -m "$(./release/ecos --version)"
        echo -e "ECOS CORE succefully deployed!"
    else
        echo -e "Skipped..."
    fi
}

# //////////////////////////////////
# START
# //////////////////////////////////

init "$@"
