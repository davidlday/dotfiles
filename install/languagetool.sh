#!/usr/bin/env bash

LT_VER=4.0

if can-brew; then
  brew install languagetool
else
  sudo rm -rf /opt/languagetool
  sudo mkdir -p /opt/languagetool
  curl https://languagetool.org/download/LanguageTool-${LT_VER}.zip -o /tmp/languagetool.zip
  cd /tmp
  extract ./languagetool.zip
  sudo cp -r LanguageTool-${LT_VER}/* /opt/languagetool/
  rm -rf /tmp/LanguageTool-${LT_VER}
  rm /tmp/languagetool.zip
  cd -
fi
