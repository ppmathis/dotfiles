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
	local __tmux_prefix="${1}"; shift
	local __tmux_window=""

	if [[ "$(ps -p $(ps -p $$ -o ppid=) -o comm= | cut -d':' -f1)" == "tmux" ]]; then
		__tmux_window="$(__tmux_get_current_window)"
		trap "tmux set-window-option -t ${__tmux_window} automatic-rename on 1>/dev/null" RETURN
		tmux rename-window "${__tmux_prefix}$(__tmux_get_hostname ${*})"
	fi

	command "${@}"
}

if __df_deps "tmux"; then
	[[ -z "${TMUX}" ]] && {
		tmux new-session -d -s main

		exec tmux new-session -t main \; \
			set-option destroy-unattached \; \
			set-environment -g TMUX_CLIPBOARD_GET "$(__df_ralias gclip)" \; \
			set-environment -g TMUX_CLIPBOARD_SET "$(__df_ralias sclip)"
	} || {
		alias ssh='__tmux_command "@" "ssh"'
	}
fi
