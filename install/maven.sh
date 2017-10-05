#!/usr/bin/env bash
source ../shell/.function

if can-brew; then
  brew install maven
else
  echo "Skipped: maven. Install brew first (brew.sh)."
fi
