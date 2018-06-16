#!/usr/bin/env bash
source ../shell/.function

if is-executable code; then
  declare -a extensions=(
    "Arjun.swagger-viewer"
    "DavidAnson.vscode-markdownlint"
    "EditorConfig.EditorConfig"
    "adamvoss.vscode-languagetool"
    "adamvoss.vscode-languagetool-en"
    "alefragnani.rtf"
    "DotJoshJohnson.xml"
    "konstantinkai.vscode-css-to-stylus"
    "ms-python.python"
    "redhat.java"
    "sidneys1.gitconfig"
    "sysoev.language-stylus"
    "tht13.rst-vscode"
    "timonwong.shellcheck"
    "travisthetechie.write-good-linter"
    "vscjava.vscode-java-debug"
    "vscjava.vscode-java-pack"
    "vscjava.vscode-java-test"
    "vscjava.vscode-maven"
  )

  for extension in "${extensions[@]}"; do
    code --install-extension "$extension"
  done
else
  echo "Visual Studio Code command line not installed."
fi
