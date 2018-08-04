export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export HISTSIZE="32768"
export HISTFILESIZE="${HISTSIZE}"
export HISTCONTROL="ignoreboth"

_path_=$(command -v "vim") && export EDITOR="${_path_}"
_path_=$(command -v "less") && export MANPAGER="${_path_} -X"

if [[ -z "${SSH_AUTH_SOCK}" ]] || ([[ -z "${SSH_CLIENT}" ]] & [[ -z "${SSH_TTY}" ]]); then
	if [[ -S "${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh" ]]; then
		export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
	else
		eval "$(ssh-agent -s)"
	fi
fi
