#!/usr/bin/env bash
source ../shell/.function

if is-executable apm; then
  apm install \
    atom-focus-mode \
    busy-signal \
    editorconfig \
    git-plus \
    intentions \
    linter \
    linter-languagetool \
    linter-ui-default \
    linter-write-good \
    open-terminal-here \
    wordcount
fi
