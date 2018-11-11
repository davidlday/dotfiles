#!/usr/bin/env bash

# Not strictly necessary, but left over from old readlink/greadlink.
REALPATH=$(command -v realpath)

# Find current script source, if possible
CURRENT_SCRIPT="${BASH_SOURCE[0]}"

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without realpath and/or $BASH_SOURCE/$0)
if [[ -n $CURRENT_SCRIPT && -x "$REALPATH" ]]; then
  SCRIPT_PATH=$($REALPATH "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Source functions, assuming they're not already
# shellcheck source=/dev/null
source "$DOTFILES_DIR/shell/.function"

echo "Attempting to install Visual Studio Code..."
if ! is-executable code; then
  if ! is-macos; then
    if can-apt; then
      curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
      sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
      sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
      sudo apt-get update
      sudo apt-get install code # or code-insiders
    elif is-executable rpm; then
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
      sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
      if can-dnf; then
        sudo dnf check-update
        sudo dnf install code
      elif can-yum; then
        sudo yum --assumeyes check-update
        sudo yum --assumeyes install code
      else
        echo "Hmmm - rpm is available, but dnf and yum aren't. What the heck, bro?"
      fi
    else
      echo "Can't use apt or rpm. What the heck, bro?"
    fi
  else
    echo "Man, you're on a Mac! Download and install it yerself, fool!"
  fi
else
  echo "Looks like Visual Studio Code's already installed. Try running an update, bro!"
fi

if is-executable code; then
  echo "Installing Visual Studio Code extensions."
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
fi
