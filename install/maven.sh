#!/usr/bin/env bash
source ../shell/.function

if is-macos; then
  brew install maven
else
  sudo apt install -y maven
fi
