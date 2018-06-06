#!/usr/bin/env bash
source ../shell/.function

if is-executable apm; then
  apm install \
    atom-focus-mode \
    atom-beautify \
    atom-trello \
    busy-signal \
    editorconfig \
    file-icons \
    git-plus \
    intentions \
    linter \
    linter-languagetool \
    linter-shellcheck \
    linter-ui-default \
    linter-write-good \
    open-terminal-here \
    wordcount
fi
