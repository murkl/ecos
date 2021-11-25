#!/bin/bash
TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

THEME_REPO_DIR="$TWEAK_CACHE_DIR/repo"
THEME_GIT_URL="https://github.com/vinceliuice/WhiteSur-gtk-theme.git"
THEME_INSTALL_DIR="/usr/share/themes/WhiteSur-light"

install() {
    rm -rf "$THEME_REPO_DIR"
    mkdir -p "$THEME_REPO_DIR"
    git clone "$THEME_GIT_URL" "$THEME_REPO_DIR"
    update
}

remove() {
    if [ -f $THEME_REPO_DIR/install.sh ]; then
        sudo $THEME_REPO_DIR/install.sh --remove
    fi
    if [ -d $THEME_REPO_DIR ]; then
        rm -rf "$THEME_REPO_DIR"
    fi
}

update() {
    cd "$THEME_REPO_DIR" || exit 1

    git reset --hard
    git pull

    # $THEME_REPO_DIR/install.sh --color light --icon simple --nautilus-style glassy --monterey --size 280 --background default --highdefinition --theme default --normalshowapps --panel-opacity 30
    sudo $THEME_REPO_DIR/install.sh --silent-mode --icon simple --nautilus-style glassy --size 280 --background blank --theme default --normalshowapps

    # Firefox must have been started once:
    sudo $THEME_REPO_DIR/tweaks.sh --silent-mode --firefox

    # Disable App Icon
    local APP_START='#panel .panel-button .app-menu-icon {'
    local APP_CONTENT='  width: 0;\n  height: 0;\n  margin: 0;'
    local APP_END='}'

    # Modify Tray Icon Space
    local STATUS_START='#panel .panel-button .system-status-icon {'
    local STATUS_CONTENT='  icon-size: 16px;\n  padding: 4px 10px;\n  margin: 0 1px;'
    local STATUS_END='}'

    local STATUS_PADDING_START='#panel .panel-button {'
    local STATUS_PADDING_CONTENT='  -natural-hpadding: 4px;\n  -minimum-hpadding: 4px;\n  font-weight: normal;\n  color: white;\n  transition-duration: 150ms;\n  border-radius: 6px;'
    local STATUS_PADDING_END='}'

    # https://fahdshariff.blogspot.com/2012/12/sed-mutli-line-replacement-between-two.html
    local THEME_CSS_FILE="$THEME_INSTALL_DIR/gnome-shell/gnome-shell.css"

    sudo sed -ni "/$STATUS_START/{p;:a;N;/$STATUS_END/!ba;s/.*\n/$STATUS_CONTENT\n/};p" "$THEME_CSS_FILE"
    sudo sed -ni "/$STATUS_PADDING_START/{p;:a;N;/$STATUS_PADDING_END/!ba;s/.*\n/$STATUS_PADDING_CONTENT\n/};p" "$THEME_CSS_FILE"
    sudo sed -ni "/$APP_START/{p;:a;N;/$APP_END/!ba;s/.*\n/$APP_CONTENT\n/};p" "$THEME_CSS_FILE"
}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi