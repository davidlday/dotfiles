#!/usr/bin/env bash
source ../shell/.function

# Install Homebrew or linuxbrew
if ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  exit 1
fi

if ! can-brew; then
  if is-macos; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    if is-executable apt && can-sudo; then
      sudo apt-get --yes install build-essential curl file git python-setuptools ruby
    elif is-executable yum && can-sudo; then
      sudo yum groupinstall 'Development Tools' && sudo yum install curl file git python-setuptools ruby
    fi
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    if [ -d /home/linuxbrew/.linuxbrew ]; then
      prepend-path "/home/linuxbrew/.linuxbrew/bin"
      export PATH
    elif [ -d "$HOME/.linuxbrew" ]; then
      prepend-path "${HOME}/.linuxbrew/bin"
      export PATH
    fi
  fi
else
  echo "Brew already installed. Running updates."
fi

dedupe-path

brew update
brew upgrade

# Install coreutils on mac
if is-macos; then
  brew install \
    coreutils
fi

# Install good stuff on everything
brew install \
  cookiecutter \
  curl \
  git \
  bash-git-prompt
  maven \
  pandoc \
  python \
  python@2 \
  ruby \
  shellcheck \
  sqlite \
  travis \
  tree \
  vim

echo "Brew installation done."
