#!/usr/bin/env bash
source ../shell/.function

if ! can-brew; then
  source ./brew.sh
else
  brew install languagetool
fi
