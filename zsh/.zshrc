source_recursive() {
	local _directory="${1%/}"
	local _glob_pattern="${2}"
	local -a _files=()

	if [[ -d "${_directory}" ]]; then
		setopt GLOB_SUBST
		_files=("${_directory}"/${_glob_pattern})
		unsetopt GLOB_SUBST

		for _file in "${_files[@]}"; do
			if [[ -e "${_file}" ]]; then
				source "${_file}"
			fi
		done
	fi
}

declare -gr SCRIPT_PATH="$(dirname -- "$(readlink -f -- "${(%):-%N}")")"
declare -gr DOT="$(readlink -f -- "${SCRIPT_PATH}/..")"
export DOT

source_recursive "${SCRIPT_PATH}/zshrc.d/" '*.zsh'
