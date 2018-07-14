__tmux_get_hostname() {
	local _host="$(echo $* | rev | cut -d' ' -f1 | rev)"
	if echo "${_host}" | grep -E '^([0-9]+\.){3}[0-9]+' -q; then
		echo "${_host}"
	else
		if echo "${_host}" | grep -E '^([^.]+\.){2}ssx\.li' -q; then
			echo "${_host}" | cut -d'.' -f1,2
		else
			echo "${_host}" | cut -d'.' -f1
		fi
	fi
}

__tmux_get_current_window() {
	tmux list-windows | awk -F : '/\(active\)$/{print $1}'
}

__tmux_command() {
	local __tmux_window

	if [[ "$(ps -p $(ps -p $$ -o ppid=) -o comm= | cut -d':' -f1)" == "tmux" ]]; then
		__tmux_window="$(__tmux_get_current_window)"
		trap "tmux set-window-option -t ${__tmux_window} automatic-rename on 1>/dev/null" RETURN
		tmux rename-window "$(__tmux_get_hostname ${*})"
	fi

	command "${@}"
}

if command -v "${_dependency_}" &>/dev/null; then
	[[ -z "${TMUX}" ]] && { tmux attach || exec tmux new-session && exit; }

	alias ssh='__tmux_command ssh'
fi
