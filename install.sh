#!/usr/bin/env bash
source "$(dirname "${0}")/scripts/ssbl.sh"

declare DF_PACKAGES=""
readonly DF_SOURCE="${SSBL_SCRIPT_PATH}"
readonly DF_TARGET="${HOME}"
readonly DF_PACKAGE_LIST_FILE="${DF_TARGET}/.dotfiles.pkg"

# [Function] df_package {{{
df_package() {
	local _package="${1}"
	local _subpackage="${2}"

	[[ -z "${DF_PACKAGES}" ]] && df_package_list
	if [[ "${DF_PACKAGES,,}" == *"${_package,,}"* ]]; then
		ssbl_log "Executing subpackage [${_subpackage}] as part of package [${_package}]..."
		return 0
	else
		return 1
	fi
}
# }}}
# [Function] df_package_list {{{
df_package_list() {
	local _package

	DF_PACKAGES="Common"
	if [[ -f "${DF_PACKAGE_LIST_FILE}" ]]; then
		ssbl_log "Found package list: ${DF_PACKAGE_LIST_FILE}"
		while read -r _package; do
			ssbl_log "Added package: ${_package}"
			DF_PACKAGES="${DF_PACKAGES} ${_package}"
		done < "${DF_PACKAGE_LIST_FILE}"
	fi
}
# }}}
# [Function] df_custom_command {{{
df_custom_command() {
	ssbl_log "Custom Command:" "${@}"
	ssbl_debug_cmd "${@}"
}
# }}}
# [Function] df_link {{{
df_link() {
	local _link_source="${DF_SOURCE}/${1}"
	local _link_target="${DF_TARGET}/${2}"

	ssbl_log "Symlink: ${_link_target} => ${_link_source}"
	if [[ ! -e "${_link_source}" ]]; then
		ssbl_fatal "Dangling symlink to ${_link_source}"
	fi

	ssbl_debug_cmd mkdir -vp "$(dirname "${_link_target}")"
	ssbl_debug_cmd ln -vfs "${_link_source}" "${_link_target}"
}
# }}}
# [Function] df_git {{{
df_git() {
	local _git_source="${1}"
	local _git_target="${DF_SOURCE}/thirdparty/${2}"

	ssbl_log "Git Clone: ${_git_source} => ${_git_target}"
	ssbl_debug_cmd mkdir -vp "${_git_target}"
	[[ ! -d "${_git_target}/.git" ]] && git clone --recursive "${_git_source}" "${_git_target}"

	pushd "${_git_target}" >/dev/null
	ssbl_debug_cmd git checkout master
	ssbl_debug_cmd git remote update -p
	ssbl_debug_cmd git merge --ff-only '@{u}'
	ssbl_debug_cmd git submodule update --init --recursive
	popd >/dev/null
}
# }}}

# [Package - Common] Cleanup {{{
df_package "Common" "Cleanup" && {
	ssbl_debug_cmd rm -vrf "${DF_SOURCE}/thirdparty/antigen"
	ssbl_debug_cmd rm -vrf "${DF_TARGET}/.antigen"
}
# }}}
# [Package - Common] Shell {{{
df_package "Common" "Shell" && {
	df_git "https://github.com/chriskempson/base16-shell.git" "base16-shell"
	df_git "https://github.com/zplug/zplug.git" "zplug"
	df_link "shell/zshrc" ".zshrc"
}
# }}}
# [Package - Common] tmux {{{
df_package "Common" "tmux" && {
	df_link "tmux/tmux.conf" ".tmux.conf"
}
# }}}
# [Package - Common] Git {{{
df_package "Common" "Git" && {
	df_link "git/gitattributes" ".gitattributes"
	df_link "git/gitconfig" ".gitconfig"
	df_link "git/gitignore" ".gitignore"
}
# }}}
# [Package - Common] GnuPG {{{
df_package "Common" "GnuPG" && {
	df_link "gpg/gpg.conf" ".gnupg/gpg.conf"
	df_link "gpg/gpg-agent.conf" ".gnupg/gpg-agent.conf"
}
# }}}
# [Package - Common] Vim {{{
df_package "Common" "Vim" && {
	df_git "https://github.com/VundleVim/Vundle.vim.git" "vundle"
	df_git "https://github.com/chriskempson/base16-vim" "base16-vim"

	df_custom_command mkdir -vp "${DF_TARGET}/.vim/bundle"
	df_link "vim/vimrc" ".vimrc"
	df_link "thirdparty/vundle" ".vim/bundle/Vundle.vim"
	df_custom_command vim +PluginInstall +qall
}
# }}}

# [Package - Workstation] X11 {{{
df_package "Workstation" "X11" && {
	df_link "x11/xinitrc" ".xinitrc"
	df_link "x11/Xresources" ".Xresources"
}
# }}}
# [Package - Workstation] GTK {{{
df_package "Workstation" "GTK" && {
	df_link "gtk/gtk2-settings" ".gtkrc-2.0"
	df_link "gtk/gtk3-settings" ".config/gtk-3.0/settings.ini"
	df_link "gtk/gtk3-stylesheet" ".config/gtk-3.0/gtk.css"
}
# }}}
# [Package - Workstation] bspwm {{{
df_package "Workstation" "bspwm" && {
	df_link "bspwm/bspwmrc" ".config/bspwm/bspwmrc"
}
# }}}
# [Package - Workstation] sxhkd {{{
df_package "Workstation" "sxhkd" && {
	df_link "sxhkd/sxhkdrc" ".config/sxhkd/sxhkdrc"
}
# }}}
# [Package - Workstation] Termite {{{
df_package "Workstation" "termite" && {
	df_link "termite/config" ".config/termite/config"
}
# }}}
# [Package - Workstation] Compton {{{
df_package "Workstation" "Compton" && {
	df_link "compton/config" ".config/compton/config"
}
# }}}
# [Package - Workstation] Polybar {{{
df_package "Workstation" "Polybar" && {
	df_link "polybar/config" ".config/polybar/config"
}
# }}}
# [Package - Workstation] Dunst {{{
df_package "Workstation" "dunst" && {
	df_link "dunst/dunstrc" ".config/dunst/dunstrc"
}
# }}}
# [Package - Workstation] Redshift {{{
df_package "Workstation" "Redshift" && {
	df_link "redshift/redshift.conf" ".config/redshift.conf"
}
# }}}
# [Package - Workstation] Profanity {{{
df_package "Workstation" "Profanity" && {
	df_link "profanity/profrc" ".config/profanity/profrc"
	df_link "profanity/base16-tomorrow-night" ".config/profanity/themes/base16-tomorrow-night"
}
# }}}
#  [Package - Workstation] Scripts {{{
df_package "Workstation" "scripts" && {
	df_link "scripts/ssbl.sh" ".local/lib/ssbl.sh"
	df_link "scripts/backlight.sh" ".local/bin/backlight.sh"
	df_link "scripts/wallpaper.sh" ".local/bin/wallpaper.sh"
}
# }}}

exit 0
# vim:foldmethod=marker:foldlevel=0
