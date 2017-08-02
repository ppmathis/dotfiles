# Set SSH authentication agent to GnuPG SSH agent if unset
if [[ -z "${SSH_AUTH_SOCK}" ]]; then
	GPG_SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
	if [[ -S "${GPG_SSH_AUTH_SOCK}" ]]; then
		export SSH_AUTH_SOCK="${GPG_SSH_AUTH_SOCK}/gnupg/S.gpg-agent.ssh"
	fi
fi
