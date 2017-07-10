function bindkey_terminfo {
	local KEYNAME="${1}"
	local FUNCTION="${2}"
	local MAPPING="${terminfo[$KEYNAME]}"

	if [[ "${MAPPING}" != "" ]]; then
		bindkey "${MAPPING}" "${FUNCTION}"
		return 0
	else
		return 1
	fi
}

autoload -U edit-command-line
zle -N edit-command-line

bindkey -e
bindkey '\ew' kill-region
bindkey -s '\el' 'ls\n'
bindkey '^r' history-incremental-search-backward
bindkey ' ' magic-space
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^?' backward-delete-char
bindkey '\C-x\C-e' edit-command-line
bindkey '^[m' copy-prev-shell-word

bindkey_terminfo kcuu1 history-substring-search-up
bindkey_terminfo kcud1 history-substring-search-down
bindkey_terminfo kpp up-line-or-history
bindkey_terminfo knp down-line-or-history
bindkey_terminfo khome beginning-of-line
bindkey_terminfo kend end-of-line
bindkey_terminfo kdch1 delete-char || {
	bindkey '^[[3~' delete-char
	bindkey '^[3;5~' delete-char
	bindkey '\e[3~' delete-char
}
