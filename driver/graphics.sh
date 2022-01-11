#!/bin/bash
TITLE="Graphics Driver"
menu_entries=()
menu_entries+=(Intel\ Graphics\ Driver)
menu_entries+=("NVIDIA Graphics Driver")
menu_entries+=("AMD Graphics Driver")

#if ! zenity_result="$(zenity --list --hide-header --column="" --text="$TITLE" --cancel-label='Exit' --ok-label='Ok' "${menu_entries[@]}")"; then
if ! zenity_result="$($ECOS_CORE --api zenity ${menu_entries[@]})"; then
    exit 0
fi

echo "$zenity_result"

if [ "$zenity_result" = "Intel Graphics Driver" ]; then
    exit 0
fi

if [ "$zenity_result" = "NVIDIA Graphics Driver" ]; then
    exit 0
fi

if [ "$zenity_result" = "AMD Graphics Driver" ]; then
    exit 0
fi
