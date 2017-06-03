function omz_termsupport_precmd {
	emulate -L zsh

	if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
		return
	fi

	title '${ZSH_THEME_TERM_TAB_TITLE_PREFIX}%~' '${ZSH_THEME_TERM_TITLE_PREFIX}%~'
}

function omz_termsupport_preexec {
	emulate -L zsh
	setopt extended_glob

	if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
		return
	fi

	local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
	local LINE="${2:gs/%/%%}"

	title '${ZSH_THEME_TERM_TAB_TITLE_PREFIX}$CMD' '${ZSH_THEME_TERM_TITLE_PREFIX}%100>...>$LINE%<<'
}

ZSH_THEME_TERM_TITLE_PREFIX="%n@%M: "
ZSH_THEME_TERM_TAB_TITLE_PREFIX=$ZSH_THEME_TERM_TITLE_IDLE
