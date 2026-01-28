#!/bin/sh
# shellcheck shell=sh

# Paths
dot_path_append "${HOME}/.local/bin"
dot_path_append "${HOME}/go/bin"
dot_path_append "${HOME}/.composer/vendor/bin"
dot_path_append "${HOME}/Library/Application Support/JetBrains/Toolbox/scripts"

# Configs
export UV_NATIVE_TLS="true"

# Homebrew
if [ -x "/opt/homebrew/bin/brew" ]; then
  export HOMEBREW_CASK_OPTS="--require-sha"
  export HOMEBREW_NO_ANALYTICS="1"
  export HOMEBREW_NO_INSECURE_REDIRECT="1"

  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# NVM via Homebrew
if [ -d "/opt/homebrew/opt/nvm" ]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# Rustup
if [ -f "${HOME}/.cargo/env" ]; then
  . "${HOME}/.cargo/env"
fi

# 1Password CLI
if [ -f "${HOME}/.config/op/plugins.sh" ]; then
  . "${HOME}/.config/op/plugins.sh"
fi

# Local Profile
if [ -f "${HOME}/.local.sh" ]; then
  . "${HOME}/.local.sh"
fi

# Herd
if [ -d "/Applications/Herd.app" ]; then
  dot_path_append "${HOME}/Library/Application Support/Herd/bin/"
  for _version_dir in "$HOME/Library/Application Support/Herd/config/php/"*/; do
    _version_name="$(basename "${_version_dir%/}")"
    export "HERD_PHP_${_version_name}_INI_SCAN_DIR=${_version_dir}"
  done
  unset _version_dir _version_name
fi
