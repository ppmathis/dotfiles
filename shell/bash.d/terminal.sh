shopt -s checkwinsize
shopt -s histappend
shopt -s histreedit
shopt -s no_empty_cmd_completion

if [[ "${UID}" != 0 ]]; then
	shopt -s cdspell
	shopt -s nocaseglob
fi

export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
