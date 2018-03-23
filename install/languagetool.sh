#!/usr/bin/env bash
source ../shell/.function

LT_VER=4.0

if ! can-brew; then
  source ./brew.sh
else
  brew install languagetool
fi
