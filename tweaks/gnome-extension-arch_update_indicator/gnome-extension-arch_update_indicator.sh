#!/bin/bash
# https://github.com/RaphaelRochet/arch-update/wiki

TWEAK_RES_DIR="$2"
TWEAK_CACHE_DIR="$3"

install() {
    remove
    curl -Ls "https://github.com/RaphaelRochet/arch-update/releases/download/v45/arch-update@RaphaelRochet.zip" -o "$TWEAK_CACHE_DIR/arch-update@RaphaelRochet.zip"
    unzip "$TWEAK_CACHE_DIR/arch-update@RaphaelRochet.zip" -d "$HOME/.local/share/gnome-shell/extensions/arch-update@RaphaelRochet"
    gnome-extensions enable "arch-update@RaphaelRochet"

    # Configuration
    # dconf dump /org/gnome/shell/extensions/arch-update/
    dconf write /org/gnome/shell/extensions/arch-update/always-visible false
    dconf write /org/gnome/shell/extensions/arch-update/auto-expand-list 0
    dconf write /org/gnome/shell/extensions/arch-update/check-cmd "/bin/sh -c \"(/usr/bin/checkupdates; /usr/bin/paru -Qqu --color never | sed 's/Get .*//') | sort -u -t' ' -k1,1\""
    dconf write /org/gnome/shell/extensions/arch-update/check-interval 360
    dconf write /org/gnome/shell/extensions/arch-update/position 2
    dconf write /org/gnome/shell/extensions/arch-update/position-number 0
    dconf write /org/gnome/shell/extensions/arch-update/show-count true
    dconf write /org/gnome/shell/extensions/arch-update/update-cmd "gnome-terminal -e 'bash -c  \"ecos\"'"
    dconf write /org/gnome/shell/extensions/arch-update/use-buildin-icons false
}

remove() {
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/arch-update@RaphaelRochet*
}

update() {
    install
}

if [ "$1" = "install" ]; then install "$@"; fi
if [ "$1" = "remove" ]; then remove "$@"; fi
if [ "$1" = "update" ]; then update "$@"; fi
