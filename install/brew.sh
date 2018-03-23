#!/usr/bin/env bash
source ../shell/.function

# Install Homebrew or linuxbrew
if ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
fi

if ! can-brew; then
  if is-macos; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    if is-executable apt && can-sudo; then
      sudo apt-get install build-essential curl file git python-setuptools
    elif is-executable yum && can-sudo; then
      sudo yum groupinstall 'Development Tools' && sudo yum install curl file git python-setuptools
    fi
    if [ -d /home/linuxbrew/.linuxbrew ]; then
      prepend-path "/home/linuxbrew/.linuxbrew/bin"
      export PATH
    elif [ -d ~/.linuxbrew ]; then
      prepend-path "${HOME}/.linuxbrew/bin"
      export PATH
    fi
  fi
fi

dedupe-path

brew update
brew upgrade

# Install good stuff on mac
if is-macos; then
  brew install \
    vim \
    curl \
    maven
fi
