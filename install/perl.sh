#!/usr/bin/env bash
source ../shell/.function

# plenv
if can-brew; then
  brew update
  brew upgrade
  brew install plenv
  brew install perl-build
else
  echo "Skipped: plenv. Install brew first (brew.sh)."
fi
