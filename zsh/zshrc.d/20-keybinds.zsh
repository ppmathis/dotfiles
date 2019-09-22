function bindkey_terminfo() {
	local _key="${1}"
	local _command="${2}"
	local _mapping="${terminfo[${_key}]}"

	if [[ "${_mapping}" != "" ]]; then
		bindkey "${_mapping}" "${_command}"
		return 0
	else
		return 1
	fi
}

bindkey -e						# Use emacs key bindings

bindkey '\ew' kill-region				# [Esc-w] Kill from beginning of line to cursor
bindkey -s '\el' 'ls\n'					# [Esc-l] Run command "ls"
bindkey '^r' history-incremental-search-backward	# [Ctrl-r] Search history incrementally backwards
bindkey ' ' magic-space					# [Space] History Expansion
bindkey '^[[1;5C' forward-word				# [Ctrl-RightArrow] Move one word forward
bindkey '^[[1;5D' backward-word				# [Ctrl-LeftArrow] Move one word backward

bindkey_terminfo 'kcuu1' history-substring-search-up	# [UpArrow] Fuzzy find history forward
bindkey_terminfo 'kcud1' history-substring-search-down	# [DownArrow] Fuzzy find history backward
bindkey_terminfo 'kpp' up-line-or-history		# [PageUp] Up one line of history
bindkey_terminfo 'knp' down-line-or-history		# [PageDown] Down one line of history
bindkey_terminfo 'kcbt' reverse-menu-complete		# [Shift-Tab] Move through completion menu backwards

bindkey_terminfo 'khome' beginning-of-line		# [Home] Go to beginning of line
bindkey_terminfo 'kend' end-of-line			# [End] Go to end of line

bindkey '^?' backward-delete-char			# [Backspace] Delete character backward
bindkey_terminfo 'kdch1' delete-char || {		# [Delete] Delete character forward
	bindkey '^[[3~' delete-char
	bindkey '^[3;5~' delete-char
	bindkey '\e[3~' delete-char
}

# Modify current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
