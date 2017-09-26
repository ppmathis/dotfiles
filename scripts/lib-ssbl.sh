#!/usr/bin/env bash
# SSBL - SnapServ Bash Library
################################################################################

# Activate various safety features
set -o errexit
set -o pipefail
set -o nounset

# Declare various variables and constants
declare IFS=$'\n\t'
readonly SSBL_DEBUG="${DEBUG:-}"
readonly SSBL_TRACE="${TRACE:-}"
readonly SSBL_SCRIPT_PATH="$(cd "$(dirname "${0}")"; pwd -P)"

# Enable script tracing when SSBL_TRACE is enabled
[[ ! -z "${SSBL_TRACE}" ]] && set -o xtrace

# Logs a message prepend with the current time
ssbl_log() {
	echo -e "[$(date --rfc-3339=seconds)]" "${@}"
}

# Same as ssbl_log, but suppressed output if SSBL_TRACE is not enabled
ssbl_debug() {
	if [[ ! -z "${SSBL_DEBUG}" ]]; then
		ssbl_log "${@}"
	fi
}

# Executes and logs a command with indented output
ssbl_log_cmd() {
	ssbl_log "COMMAND:" "${@}" "$("${@}" 2>&1 | sed '1s/^\(.\)/\n\1/' | sed 's/^/\t/')"
}

# Same as ssbl_log_cmd, but suppressed output if SSBL_TRACE is not enabled
ssbl_debug_cmd() {
	if [[ ! -z "${SSBL_DEBUG}" ]]; then
		ssbl_log_cmd "${@}"
	else
		"${@}" &>/dev/null
	fi
}

# Logs a fatal error and immediately exits the script
ssbl_fatal() {
	local _message="${1}"
	local _exit_code="${2:-1}"
	ssbl_log "FATAL ERROR: ${_message}" >&2
	exit "${_exit_code}"
}

# Requires a command to exist (checked with 'hash' builtin)
ssbl_req_cmd() {
	local _command="${1}"
	if ! hash "${_command}" &>/dev/null; then
		ssbl_fatal "Required command not found in PATH: ${_command}"
	fi
}
