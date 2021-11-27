#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"


# //////////////////////////////////
# INIT
# //////////////////////////////////

ecos_release() {

    echo -e ''
    echo -e "////////////////////////"
    echo -e "> RELEASE NEW ECOS CORE"
    echo -e "////////////////////////"
    echo -e "VERSION DEVELOP:  $DEVELOP_VERSION"
    echo -e "VERSION RELEASE:  $RELEASE_VERSION"
    echo -e ''

    # Vars
    local show_warning="false"

    # Check different version numbers
    if [ "$DEVELOP_VERSION" = "$RELEASE_VERSION" ]; then
        show_warning="true"
        printf "${COLOR_RED}!! SAME VERSION NUMBERS !!${COLOR_NULL}\n"
    fi

    # Check different changelog files
    if diff "$DEVELOP_CHANGELOG" "$RELEASE_CHANGELOG" >/dev/null 2>&1; then
        show_warning="true"
        printf "${COLOR_RED}!! NO CHANGELOG UPDATE !!${COLOR_NULL}\n"
    fi

    # Show warning
    if [ "$show_warning" = "true" ]; then
        echo -e ''
        read -p "CONTINUE ANYWAY? [y/n]: " user_input
        if [ "$user_input" != "y" ]; then
            echo -e "Skipped..."
            exit 0
        fi
    fi

    # DEPLOYMENT
    echo -e ''
    read -p "DEPLOY ECOS $DEVELOP_VERSION? [yes/no]: " user_input
    if [ "$user_input" = "yes" ]; then

        # Copy dev to release
        if ! cp -f "$DEVELOP_SCRIPT" "$RELEASE_SCRIPT"; then
            echo -e "ERROR: cp -f "$DEVELOP_SCRIPT" "$RELEASE_SCRIPT""
            exit 1
        fi

        # Git commit
        cd "$SCRIPT_DIR" || exit 1
        git add "./release/ecos" && git commit -m "$(./release/ecos --version)"
        echo -e "ECOS CORE succefully released!"
    else
        echo -e "Skipped..."
    fi
}

# //////////////////////////////////
# START
# //////////////////////////////////

init "$@"
