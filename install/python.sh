#!/usr/bin/env bash
source ../shell/.function

if is-macos; then
  if ! can-brew; then
    source ./brew.sh
  fi
  # Use Homebrew on Mac
  brew install python python@2
elif is-executable apt && can-sudo; then
  # Use native packages on debian systems (for now)
  sudo apt install -y python python3 python-pip virtualenv virtualenvwrapper
fi
