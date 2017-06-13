#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCREEN_RESOLUTION=$(xrandr -q | awk -F'current' -F',' 'NR==1 {gsub("( |current)","");print $2}')
WALLPAPER_BASE_FOLDER="${HOME}/pictures/wallpapers"
WALLPAPER_RESOLUTION_FOLDER="${WALLPAPER_BASE_FOLDER}/${SCREEN_RESOLUTION}/"

if [ -d "${WALLPAPER_RESOLUTION_FOLDER}" ]; then
	feh --randomize --bg-fill --no-fehbg --no-xinerama "${WALLPAPER_RESOLUTION_FOLDER}"
else
	notify-send -u normal "Wallpaper Rotation" "Unable to fetch random wallpaper\!\nUnsupported resolution: ${SCREEN_RESOLUTION}"
fi
