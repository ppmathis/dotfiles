#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# shellcheck disable=2155
declare -gr DOT="$(cd "$(dirname "$0")"; pwd -P)"

declare -gra BASE_PACKAGES=(
	zsh
)

declare -gra USER_PACKAGES=(
	fonts
	git
	tilix
	vim
)

# shellcheck disable=2059
_log() {
	local _level _message

	_level="${1}"; shift
	_message="$(printf "${@}")"
	printf '[%s] %-5s: %s\n' "$(date -Iseconds)" "${_level}" "${_message}"
}

log_info() { _log "INFO" "${@}"; }
log_warn() { _log "WARN" "${@}"; }
log_error() { _log "ERROR" "${@}"; }
log_fatal() { _log "FATAL" "${@}"; exit 1; }

pkg_stow() {
	local _package="${1}"
	local _target="${2:-${HOME}}"

	log_info "Stowing package [${_package}] to [${_target}]..."
	stow -v -R -d "${DOT}" -t "${_target}" "${_package}" 2>&1 \
		| grep -e "^LINK:" || true
}

main() {
	log_info "Stowing base packages..."
	for _package in "${BASE_PACKAGES[@]}"; do
		pkg_stow "${_package}"
	done
	
	if [[ $EUID -ne 0 ]]; then
		log_info "Stowing user packages..."
		for _package in "${USER_PACKAGES[@]}"; do
			pkg_stow "${_package}"
		done
	else
		log_info "Skipped stowing of user packages for root"
	fi
}

main "${@}"
