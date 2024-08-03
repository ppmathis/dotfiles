#!/bin/sh
# shellcheck shell=sh

# Binaries: macOS
dot_alias_cmd firefox '/Applications/Firefox.app/Contents/MacOS/firefox'
dot_alias_cmd tailscale '/Applications/Tailscale.app/Contents/MacOS/Tailscale'

# Compatibility: macOS
dot_only_macos alias hd='hexdump -C'
dot_only_macos alias md5sum='md5 -r'
dot_only_macos alias sha1sum='shasum -a 1'
dot_only_macos alias sha256sum='shasum -a 256'
dot_only_macos alias sha512sum='shasum -a 512'

# Defaults
alias bat='bat -A'
alias ls='command ls --color=auto'
alias ll='ls -alF'

# Nesting
alias sudo='sudo '
alias watch='watch '
alias xargs='xargs '

# Safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Safety: Linux
dot_only_linux alias chgrp='chgrp --preserve-root'
dot_only_linux alias chmod='chmod --preserve-root'
dot_only_linux alias chown='chown --preserve-root'
dot_only_linux alias rm='rm --preserve-root'

# Utilities
alias bell='tput bel'
alias map='xargs -n1'
alias path='echo -e "${PATH}" | tr ":" "\n"'
alias reload='exec "${SHELL}" -l'

# dns: Resolve DNS records using dig with minimal output
dns() {
  dig +noall +nocmd +multiline +answer "$@"
}

# mkd: Create a directory verbosely and change to it
mkd() {
  mkdir -vp "${1}"
  cd "${1}" || return
}

# open: Open a file or directory using the default application
open() {
  case "$(dot_os)" in
    macos) command open "$@" ;;
    linux) xdg-open "$@" ;;
    windows) start "$@" ;;
    *) dot_unsupported_os ;;
  esac
}

# sail: Run a command using Laravel Sail
sail() {
  if [ -x "./vendor/bin/sail" ]; then
    ./vendor/bin/sail "$@"
  else
    command sail "$@"
  fi
}
