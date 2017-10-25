#!/usr/bin/env bash

LT_VER=3.9

if is-mac; then
  brew install languagetool
else
  sudo mkdir -p /opt/languagetool
  curl https://languagetool.org/download/LanguageTool-${LT_VER}.zip -o /tmp/languagetool.zip
  cd /tmp
  extract ./languagetool.zip
  sudo cp -r LanguageTool-${LT_VER}/* /opt/languagetool/
  rm -rf /tmp/LanguageTool-${LT_VER}
  rm /tmp/languagetool.zip
fi
