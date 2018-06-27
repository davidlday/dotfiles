#!/usr/bin/env bash

# Not strictly necessary, but left over from old readlink/greadlink.
REALPATH=$(command -v realpath)

# Find current script source, if possible
CURRENT_SCRIPT="${BASH_SOURCE[0]}"

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without realpath and/or $BASH_SOURCE/$0)
if [[ -n "$CURRENT_SCRIPT" && -x "$REALPATH" ]]; then
  SCRIPT_PATH=$($REALPATH "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Source functions, assuming they're not already
# shellcheck source=/dev/null
source "$DOTFILES_DIR/shell/.function"

# Make sure brew is installed
if ! can-brew; then
  # shellcheck source=/dev/null
  source "$DOTFILES_DIR/install/brew.sh"
fi

# Install dependencies if needed
if ! is-macos; then
  if can-sudo; then
    echo "Installing pyenv dependencies."
    if can-apt; then
      sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev
    elif can-dnf; then
      sudo dnf -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel
    elif can-yum; then
      sudo yum -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel
    else
      echo "Bro, not on a Mac and can't apt, dnf, or yum! What platform you on?"
      exit 1
    fi
  else
    echo "Not on a Mac and can't sudo, bro! Even with brew ya need sudo!"
    exit 1
  fi
fi

# Install pyenv
echo "Installing pyenv via brew..."
brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper
echo "Pyenv installed."
