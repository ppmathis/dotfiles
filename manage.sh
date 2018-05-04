#!/usr/bin/env bash
source "$(dirname "${0}")/utils/ssbl.sh"
DF_SOURCE="${SSBL_SCRIPT_PATH}"
DF_TARGET="${DF_TARGET:-${HOME}}"

df_link() {
	local _source="${DF_SOURCE}/${1}"
	local _target="${DF_TARGET}/${2}"

	ssbl_log "Symlink: ${_target} => ${_source}"
	if [[ ! -e "${_source}" ]]; then
		ssbl_fatal "Dangling symlink to ${_source}"
	fi

	ssbl_debug_cmd mkdir -vp "$(dirname "${_target}")"
	ssbl_debug_cmd ln -vfs "${_source}" "${_target}"
}

df_link "shell/bashrc" ".bashrc"
df_link "x11/Xresources" ".Xresources"
df_link "gtk/gtk2-settings" ".gtkrc-2.0"
df_link "gtk/gtk3-settings" ".config/gtk-3.0/settings.ini"
df_link "git/gitattributes" ".gitattributes"
df_link "git/gitconfig" ".gitconfig"
df_link "git/gitignore" ".gitignore"
df_link "tmux/tmux.conf" ".tmux.conf"

unset -f df_link
unset DF_SOURCE
unset DF_TARGET
