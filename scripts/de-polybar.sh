#!/usr/bin/env bash
source "${HOME}/.local/scripts/lib-ssbl.sh"

main() {
	# Detect hostname and active monitor name
	local _hostname="$(hostname -s)"
	local _active_monitor_name="$(xrandr -q | grep ' connected' | cut -d ' ' -f1)"
	ssbl_log "Machine Hostname: ${_hostname}"
	ssbl_log "Active Monitor Name: ${_active_monitor_name}"

	# Support host-specific setups, fallback to default
	if [[ "${_hostname}" == "gravity" ]]; then
		ssbl_log "Using host-specific setup for: gravity"
		MONITOR=DisplayPort-0 polybar -r side &
		MONITOR=DisplayPort-1 polybar -r main &
		MONITOR=DisplayPort-2 polybar -r side &
	else
		ssbl_log "Falling back to default single-instance polybar on ${_active_monitor_name}"
		MONITOR="${_active_monitor_name}" polybar -r main &
	fi
}

main "${@}"
