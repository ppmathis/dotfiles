# Easier directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# File listing aliases
alias l='ls -lF --color'
alias la='ls -laF --color'
alias lsd='ls -lF --color | grep --color=never "^d"'
alias ls='command ls --color'

# Enable colored output for grep commands
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable alias support for sudo
alias sudo='sudo '

# Get current week number
alias week='date +%V'

# Ring the terminal bell
alias bell='tput bel'

# Reloads the shell
alias reload="exec $SHELL -l"
