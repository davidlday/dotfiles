#!/usr/bin/env bash

if ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
fi

if ! is-executable brew; then
  if is-macos; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    if is-executable apt && can-sudo; then
      sudo apt install build-essential
    elif is-executable yum && can-sudo; then
      sudo yum groupinstall 'Development Tools'
    fi
    if [ -d /home/linuxbrew/.linuxbrew ]; then
      prepend-path "/home/linuxbrew/.linuxbrew/bin"
      export PATH
    elif [ -d ~/.linuxbrew ]; then
      prepend-path "${HOME}/.linuxbrew"
      export PATH
    fi
  fi
fi

dedupe-path

brew update
brew upgrade

# Install good stuff
brew install \
  vim \
  curl \
  vim \
  maven
