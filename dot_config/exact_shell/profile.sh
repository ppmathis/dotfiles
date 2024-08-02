#!/bin/sh
# shellcheck shell=sh
# shellcheck source=library.sh.tmpl
. "${HOME}/.config/shell/library.sh"

# Common
dot_path_append "${HOME}/.local/bin"

# Homebrew
if [ -x "/opt/homebrew/bin/brew" ]; then
  export HOMEBREW_CASK_OPTS="--require-sha"
  export HOMEBREW_NO_ANALYTICS="1"
  export HOMEBREW_NO_INSECURE_REDIRECT="1"

  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# JetBrains Toolbox
dot_path_append "${HOME}/Library/Application Support/JetBrains/Toolbox/bin"

# NVM via Homebrew
if [ -d "/opt/homebrew/opt/nvm" ]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi
