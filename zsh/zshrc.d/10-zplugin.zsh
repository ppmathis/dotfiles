source "${DOT}/zsh/zplugin/zplugin.zsh"

zplugin ice wait lucid
zplugin load zsh-users/zsh-history-substring-search

PS1="READY > "
zplugin ice wait'!' lucid
zplugin load denysdovhan/spaceship-prompt

zplugin ice wait atload'_zsh_autosuggest_start' lucid
zplugin load zsh-users/zsh-autosuggestions

zplugin ice wait atinit'zpcompinit' lucid
zplugin load zdharma/fast-syntax-highlighting
