source_recursive_files() {
	local DIRECTORY=${1%/}
	local GLOB=${2}

	if [ -d "${DIRECTORY}" ]; then
		for FILE in "${DIRECTORY}"/${GLOB}; do
			if [ -e "${FILE}" ]; then
				echo "${FILE}"
			fi
		done
	fi
}
