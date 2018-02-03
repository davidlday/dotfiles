#!/usr/bin/env bash
source ../shell/.function

if is-macos && can-brew; then
  # Use Homebrew on Mac
  brew install python python3 pyenv pyenv-virtualenv pyenv-virtualenvwrapper
elif is-executable apt && can-sudo; then
  # Use native packages on debian systems (for now)
  sudo apt install -y python python3 python-pip virtualenv virtualenvwrapper
fi
