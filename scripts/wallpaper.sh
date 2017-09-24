#!/usr/bin/env bash
source "${HOME}/.local/lib/ssbl.sh"

main() {
	# Detect screen resolution
	ssbl_log "Detecting screen resolution with Xrandr..."
	local _screen_resolution="$(xrandr -q | awk -F'current' -F',' 'NR==1 {gsub("( |current)","");print $2}')"
	ssbl_log "Detected screen resolution: ${_screen_resolution}"

	# Build folder paths
	local _wp_base_path="${HOME}/pictures/wallpapers"
	local _wp_resolution_path="${_wp_base_path}/${_screen_resolution}/"
	ssbl_log "Wallpaper Base Path: ${_wp_base_path}"
	ssbl_log "Wallpaper Resolution Path: ${_wp_resolution_path}"

	# Execute feh if wallpaper resolution folder exists
	if [[ -d "${_wp_resolution_path}" ]]; then
		ssbl_log_cmd feh --randomize --bg-fill --no-fehbg --no-xinerama "${_wp_resolution_path}"
	else
		ssbl_log_cmd notify-send -u normal "Wallpaper Rotation" "Unable to fetch random wallpaper\!\nUnsupported resolution: ${_screen_resolution}"
	fi
}

main "${@}"
