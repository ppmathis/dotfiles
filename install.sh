#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# [Common] Helper Functions {{{
function link() {
	echo ">> Symlink: ${DOTFILES_TARGET}/$2 --> ${DOTFILES_SOURCE}/$1"
	mkdir -p "$(dirname ${DOTFILES_TARGET}/$2)"
	ln -fs "${DOTFILES_SOURCE}/$1" "${DOTFILES_TARGET}/$2"
}

function gitdl() {
	local TARGET="${DOTFILES_SOURCE}/thirdparty/$2"
	echo ">> Cloning Git repository: $1 --> $TARGET"
	mkdir -p "${TARGET}"
	[[ ! -d "${TARGET}/.git" ]] && git clone --recursive "$1" "${TARGET}" >/dev/null
	pushd "${TARGET}" >/dev/null
	git checkout master >/dev/null 2>&1
	git remote update -p >/dev/null
	git merge --ff-only @{u} >/dev/null
	git submodule update --init --recursive >/dev/null
	popd >/dev/null
}

function package() {
	local PACKAGE_NAME="$1"
	local SUBPACKAGE_NAME="$2"

	if [[ "${PACKAGES}" == *"${PACKAGE_NAME}"* ]]; then
		echo "> Executing subpackage [${SUBPACKAGE_NAME}] as part of package [${PACKAGE_NAME}]..."
		return 0
	else
		return 1
	fi
}
# }}}
# [Common] Package List Assembler {{{
DOTFILES_SOURCE="$(cd "$(dirname "$0")"; pwd -P)"
DOTFILES_TARGET="${HOME}"
PACKAGES="generic"
PACKAGE_LIST_PATH="${HOME}/.dotfiles.pkg"

echo "> Assembling package list for installation..."
echo ">> Initial package list: ${PACKAGES}"

if [[ -f "${PACKAGE_LIST_PATH}" ]]; then
	echo ">> Found package list file: ${PACKAGE_LIST_PATH}"
	while read PACKAGE; do
		echo ">>> Added package: ${PACKAGE}"
		PACKAGES="${PACKAGES} ${PACKAGE}"
	done < "${PACKAGE_LIST_PATH}"
fi

echo "> Finished. Complete package list: ${PACKAGES}"
 # }}}

#  [Package - Generic] Shell {{{
package "generic" "shell" && {
	gitdl "https://github.com/chriskempson/base16-shell.git" "base16-shell"
	gitdl "https://github.com/zsh-users/antigen.git" "antigen"
	link "shell/zshrc" ".zshrc"
}
# }}}
# [Package - Generic] Vim {{{
package "generic" "vim" & {
	gitdl "https://github.com/VundleVim/Vundle.vim.git" "vundle"
	gitdl "https://github.com/chriskempson/base16-vim" "base16-vim"

	mkdir -p "${DOTFILES_TARGET}/.vim/bundle/"
	link "vim/vimrc" ".vimrc"
	link "thirdparty/vundle" ".vim/bundle/Vundle.vim"

	echo ">> Installing Vundle plugins"
	vim +PluginInstall +qall >/dev/null 2>&1
}
# }}}
# [Package - Generic] Git {{{
package "generic" "git" && {
	link "git/gitattributes" ".gitattributes"
	link "git/gitconfig" ".gitconfig"
	link "git/gitignore" ".gitignore"
}
# }}}
# [Package - Generic] GnuPG {{{
package "generic" "gpg" && {
	link "gpg/gpg.conf" ".gnupg/gpg.conf"
	link "gpg/gpg-agent.conf" ".gnupg/gpg-agent.conf"
}
# }}}

# [Package - Workstation] X11 {{{
package "workstation" "x11" && {
	link "x11/xinitrc" ".xinitrc"
	link "x11/Xresources" ".Xresources"
}
 # }}}
# [Package - Workstation] GTK {{{
package "workstation" "gtk" && {
	link "gtk/gtk2-settings" ".gtkrc-2.0"
	link "gtk/gtk3-settings" ".config/gtk-3.0/settings.ini"
}
# }}}
# [Package - Workstation] bspwm {{{
package "workstation" "bspwm" && {
	link "bspwm/bspwmrc" ".config/bspwm/bspwmrc"
}
# }}}
# [Package - Workstation] sxhkd {{{
package "workstation" "sxhkd" && {
	link "sxhkd/sxhkdrc" ".config/sxhkd/sxhkdrc"
}
# }}}
# [Package - Workstation] compton {{{
package "workstation" "compton" && {
	link "compton/config" ".config/compton/config"
}
# }}}
# [Package - Workstation] polybar {{{
package "workstation" "polybar" && {
	link "polybar/config" ".config/polybar/config"
}
# }}}
# [Package - Workstation] Dunst {{{
package "workstation" "dunst" && {
	link "dunst/dunstrc" ".config/dunst/dunstrc"
}
# }}}
# [Package - Workstation] redshift {{{
package "workstation" "redshift" && {
	link "redshift/redshift.conf" ".config/redshift.conf"
}
# }}}
# [Package - Workstation] profanity {{{
package "workstation" "profanity" && {
	link "profanity/profrc" ".config/profanity/profrc"
	link "profanity/base16-tomorrow-night" ".config/profanity/themes/base16-tomorrow-night"
}
# }}}
#  [Package - Workstation] Scripts {{{
package "workstation" "scripts" && {
	link "scripts/backlight.sh" ".local/bin/backlight.sh"
	link "scripts/wallpaper.sh" ".local/bin/wallpaper.sh"
}
# }}}

exit 0
# vim:foldmethod=marker:foldlevel=0
