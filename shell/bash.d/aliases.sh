deps() {
	for _dependency_ in "${@}"; do
		command -v "${_dependency_}" &>/dev/null || return 1
	done
	return 0
}

alias sudo='sudo '

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias rm='rm --preserve-root -I'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias dmesg='dmesg -T'

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias bell='tput bel'
alias ccat='egrep -v "^[[:blank:]]*#|^[[:blank:]]*$"'
alias map='xargs -n1'
alias path='echo -e "${PATH//:/\\n}"'
alias reload='exec ${SHELL} -l'
alias untar='tar xvf'
alias week='date +%V'

deps 'top' && alias top='htop'
deps 'vim' && alias vi='vim'

deps 'dig' && {
	alias wipd4='dig +short myip.opendns.com @resolver1.opendns.com'
	alias wipd6='dig +short -6 myip.opendns.com @resolver1.ipv6-sandbox.opendns.com'
}
deps 'curl' && {
	alias wip='curl https://icanhazip.com/'
	alias wip4='curl -4 https://icanhazip.com/'
	alias wip6='curl -6 https://icanhazip.com/'
}
[[ -z "${wip}" ]] && deps 'GET' && alias wip='GET https://icanhazip.com/'

if deps 'python3'; then
	alias urldecode='python3 -c "import sys, urllib.parse as lib; print(lib.unquote_plus(sys.argv[1]))"'
	alias urlencode='python3 -c "import sys, urllib.parse as lib; print(lib.quote_plus(sys.argv[1]))"'
elif deps 'python'; then
	alias urldecode='python -c "import sys, urllib as lib; print(lib.unquote_plus(sys.argv[1]))"'
	alias urlencode='python -c "import sys, urllib as lib; print(lib.quote_plus(sys.argv[1]))"'
fi

if deps 'tree'; then
	alias tree='tree -C'
	alias ltree='tree | less -R'
else
	alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'
	alias ltree='tree | less -R'
fi

if deps 'pbpaste'; then
	alias gclip='pbpaste'
	alias pclip='pbcopy'
elif deps 'xclip'; then
	alias gclip='xclip -selection clipboard -o'
	alias pclip='xclip -selection clipboard -i'
elif [[ "${SYSTEM_TYPE}" == "MINGW" ]] || [[ "${SYSTEM_TYPE}" == "CYGWIN" ]]; then
	alias gclip='cat /dev/clipboard'
	alias pclip='cat >/dev/clipboard'
fi

unset -f deps
