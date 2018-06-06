#!/usr/bin/env bash
source ../shell/.function

# Use brew on Linux and Mac
if ! can-brew; then
  source ./brew.sh
fi
# Use Homebrew on Mac
brew install python python@2
