# Resolve nested aliases
alias sudo='sudo '
alias watch='watch '
alias xargs='xargs '

# Directory traversal
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Safety measures
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias mv='mv -i'
alias cp='cp -i'

# Terminal / Shell commands
alias reload="exec ${SHELL} -l"
alias bell='tput bel'
alias path='echo -e "${PATH//:/\\n}"'

# Command shortcuts
alias dkr='sudo -- docker'
alias log='sudo -- journalctl'
alias sys='sudo -- systemctl'

# Command tweaks
alias wget='wget --content-disposition'
alias su='su -l'

# Useful commands
alias ll='ls -lAhF --group-directories-first'
alias l='ls -CF'
alias tf='truncate -s0'

alias week='date +%V'
alias ccat='egrep -v "^[[:blank:]]*#|^[[:blank:]]*$"'
alias sshni='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
