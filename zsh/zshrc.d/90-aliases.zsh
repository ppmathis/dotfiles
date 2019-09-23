alias sudo='sudo '

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias rm='rm --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias week='date +%V'
alias bell='tput bel'
alias ccat='egrep -v "^[[:blank:]]*#|^[[:blank:]]*$"'
alias path='echo -e "${PATH//:/\\n}"'
alias sshni='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

alias reload="exec ${SHELL} -l"
