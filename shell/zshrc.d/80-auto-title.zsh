function title {
	emulate -L zsh
	setopt prompt_subst

	[[ "$EMACS" == *term* ]] && return
	: ${2=$1}

	case "$TERM" in
		cygwin|xterm*|putty*|rxvt*|ansi)
			print -Pn "\e]2;$2:q\a"
			print -Pn "\e]1;$1:q\a"
			;;
		screen*)
			print -Pn "\ek$1:q\e\\"
			;;
		*)
			if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
				print -Pn "\e]2;$2:q\a"
				print -Pn "\e]1;$1:q\a"
			else
				if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
		echoti tsl
		print -Pn "$1"
		echoti fsl
	fi
			fi
			;;
	esac
}

function dotfiles_autotitle_precmd {
	emulate -L zsh

	if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
		return
	fi

	title '${ZSH_THEME_TERM_TAB_TITLE_PREFIX}%~' '${ZSH_THEME_TERM_TITLE_PREFIX}%~'
}

function dotfiles_autotitle_preexec {
	emulate -L zsh
	setopt extended_glob

	if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
		return
	fi

	local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
	local LINE="${2:gs/%/%%}"

	title '${ZSH_THEME_TERM_TAB_TITLE_PREFIX}$CMD' '${ZSH_THEME_TERM_TITLE_PREFIX}%100>...>$LINE%<<'
}

if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
	ZSH_THEME_TERM_TITLE_PREFIX="[ssh] %n@%M: "
else
	ZSH_THEME_TERM_TITLE_PREFIX="%n@%M: "
fi
ZSH_THEME_TERM_TAB_TITLE_PREFIX=$ZSH_THEME_TERM_TITLE_IDLE

precmd_functions+=(dotfiles_autotitle_precmd)
preexec_functions+=(dotfiles_autotitle_preexec)
