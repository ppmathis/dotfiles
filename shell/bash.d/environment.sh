export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export HISTSIZE="32768"
export HISTFILESIZE="${HISTSIZE}"
export HISTCONTROL="ignoreboth"

_path_=$(command -v "vim") && export EDITOR="${_path_}"
_path_=$(command -v "less") && export MANPAGER="${_path_} -X"
