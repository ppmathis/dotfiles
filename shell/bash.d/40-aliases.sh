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
alias sshni='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias untar='tar xvf'
alias week='date +%V'

__df_deps 'top' && alias top='htop'
__df_deps 'vim' && alias vi='vim'

__df_deps 'dig' && {
	alias wipd4='dig +short myip.opendns.com @resolver1.opendns.com'
	alias wipd6='dig +short -6 myip.opendns.com @resolver1.ipv6-sandbox.opendns.com'
}
__df_deps 'curl' && {
	alias wip='curl https://icanhazip.com/'
	alias wip4='curl -4 https://icanhazip.com/'
	alias wip6='curl -6 https://icanhazip.com/'
}
[[ -z "${wip}" ]] && __df_deps 'GET' && alias wip='GET https://icanhazip.com/'

if __df_deps 'python3'; then
	alias urldecode='python3 -c "import sys, urllib.parse as lib; print(lib.unquote_plus(sys.argv[1]))"'
	alias urlencode='python3 -c "import sys, urllib.parse as lib; print(lib.quote_plus(sys.argv[1]))"'
elif __df_deps 'python'; then
	alias urldecode='python -c "import sys, urllib as lib; print(lib.unquote_plus(sys.argv[1]))"'
	alias urlencode='python -c "import sys, urllib as lib; print(lib.quote_plus(sys.argv[1]))"'
fi

if __df_deps 'tree'; then
	alias tree='tree -C'
	alias ltree='tree | less -R'
else
	alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'
	alias ltree='tree | less -R'
fi

if __df_deps 'pbpaste'; then
	alias gclip='pbpaste'
	alias sclip='pbcopy'
elif __df_deps 'xclip'; then
	alias gclip='xclip -selection clipboard -o'
	alias sclip='xclip -selection clipboard -i'
elif [[ "${SYSTEM_TYPE}" == "MINGW" ]] || [[ "${SYSTEM_TYPE}" == "CYGWIN" ]]; then
	alias gclip='cat /dev/clipboard'
	alias sclip='cat >/dev/clipboard'
fi
