#!/bin/bash
TWEAK_RES_DIR="$2" && if [ -z "$2" ]; then TWEAK_RES_DIR="$(pwd)"; fi
TWEAK_CACHE_DIR="$3" && if [ -z "$3" ]; then TWEAK_CACHE_DIR="$(pwd)"; fi

THEME_REPO_DIR="$TWEAK_CACHE_DIR/repo"

install() {

    if [ ! -d $THEME_REPO_DIR ]; then
        mkdir -p "$THEME_REPO_DIR"
        git clone "https://github.com/vinceliuice/WhiteSur-gtk-theme.git" "$THEME_REPO_DIR"
    fi
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

    # Update git repo
    git reset --hard
    git pull

    # Install Theme
    # glassy
    sudo $THEME_REPO_DIR/install.sh --silent-mode --name 'ECOS' --icon simple --nautilus-style mojave --background blank --theme default --normalshowapps

    # Install GDM theme
    sudo $THEME_REPO_DIR/tweaks.sh --silent-mode --gdm

    # Install Firefox theme (Firefox must have been started once)
    sudo $THEME_REPO_DIR/tweaks.sh --silent-mode --firefox

    # Install Dash to Dock theme
    # sudo $THEME_REPO_DIR/tweaks.sh --silent-mode --dash-to-dock --color light

    modify_theme() {

        # Theme css file
        local css_file="$1"

        # Disable App Icon
        local theme_app_icon_start='#panel .panel-button .app-menu-icon {'
        local theme_app_icon_content='  width: 0;\n  height: 0;\n  margin: 0;'
        local theme_app_icon_end='}'

        # Modify Tray Icon Space
        local theme_tray_icon_start='#panel .panel-button .system-status-icon {'
        local theme_tray_icon_content='  icon-size: 16px;\n  padding: 4px 10px;\n  margin: 0 1px;'
        local theme_tray_icon_end='}'

        local theme_tray_padding_start='#panel .panel-button {'
        local theme_tray_padding_content='  -natural-hpadding: 4px;\n  -minimum-hpadding: 4px;\n  font-weight: normal;\n  color: white;\n  transition-duration: 150ms;\n  border-radius: 6px;'
        local theme_tray_padding_end='}'

        # https://fahdshariff.blogspot.com/2012/12/sed-mutli-line-replacement-between-two.html
        sudo sed -ni "/$theme_tray_icon_start/{p;:a;N;/$theme_tray_icon_end/!ba;s/.*\n/$theme_tray_icon_content\n/};p" "$css_file"
        sudo sed -ni "/$theme_tray_padding_start/{p;:a;N;/$theme_tray_padding_end/!ba;s/.*\n/$theme_tray_padding_content\n/};p" "$css_file"
        sudo sed -ni "/$theme_app_icon_start/{p;:a;N;/$theme_app_icon_end/!ba;s/.*\n/$theme_app_icon_content\n/};p" "$css_file"
    }

    # Modify theme variants
    modify_theme "/usr/share/themes/ECOS-light/gnome-shell/gnome-shell.css"
    modify_theme "/usr/share/themes/ECOS-light-solid/gnome-shell/gnome-shell.css"
    modify_theme "/usr/share/themes/ECOS-dark/gnome-shell/gnome-shell.css"
    modify_theme "/usr/share/themes/ECOS-dark-solid/gnome-shell/gnome-shell.css"

}

if [ "$1" = "--install" ]; then install "$@"; fi
if [ "$1" = "--remove" ]; then remove "$@"; fi
if [ "$1" = "--update" ]; then update "$@"; fi
