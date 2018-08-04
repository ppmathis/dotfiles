__df_deps() {
	for _dependency_ in "${@}"; do
		command -v "${_dependency_}" &>/dev/null || return 1
	done
	return 0
}

__df_ralias() {
	alias "${1}" | sed "s/^alias ${1}='\\(.*\\)'$/\\1/g"
}
