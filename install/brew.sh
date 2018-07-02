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

# Install Linux/HomeBrew depending on platform
if ! can-brew; then
  if is-macos; then
    echo "Installing HomeBrew (https://brew.sh)"
    # See: https://brew.sh/
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    if can-sudo; then
      echo "Installing LinuxBrew (https://linuxbrew.sh)"
      if can-apt; then
        sudo apt-get --yes install build-essential curl file git python-setuptools ruby
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      elif can-dnf; then
        sudo dnf groupinstall 'Development Tools' && sudo dnf install curl file git
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      elif can-yum; then
        sudo yum groupinstall 'Development Tools' && sudo yum install curl file git
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      else
        echo "Dude, you're not on a Mac and you can't apt, dnf, or yum. What the hell platform you on, bro?"
        exit 1
      fi
      echo "LinuxBrew installed."
    else
      echo "Need sudo to install LinuxBrew, bro!"
    fi
  fi
else
  echo "Brew already installed. Running updates."
fi

# shellcheck source=/dev/null
source "$DOTFILES_DIR/shell/.path"

dedupe-path

echo "Updating brew... may take a minute or so."
brew update
brew upgrade

# Install Mac-specific needs
if is-macos; then
  brew install \
    coreutils \
    ssh-copy-id
fi

# Install good stuff on everything
brew install \
  bash \
  bash-completion@2 \
  bash-git-prompt \
  cookiecutter \
  curl \
  git \
  goenv \
  languagetool \
  maven \
  pandoc \
  plenv \
  pyenv \
  pyenv-virtualenv \
  rbenv \
  shellcheck \
  sqlite \
  travis \
  tree \
  wget \
  vim

# Make sure $BREW_BASH can be used
BREW_BASH="$(brew --prefix)/bin/bash"
if is-executable "$BREW_BASH"; then
  if ! grep "$BREW_BASH" /etc/shells; then
    echo "Updating default shell for $USER."
    sudo sh -c "echo $BREW_BASH >> /etc/shells"
  fi
  chsh -s $BREW_BASH
  echo "Shell updated:"
  "$BREW_BASH" --version
  echo "You will need to log out and back in."
fi
unset BREW_BASH

echo "Brew installation done."
