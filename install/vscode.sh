#!/usr/bin/env bash
source ../shell/.function

echo "Attempting to install Visual Studio Code..."
if ! is-executable code; then
  if ! is-macos; then
    if is-executable apt; then
      curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
      sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
      sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
      sudo apt-get update
      sudo apt-get install code # or code-insiders
    elif is-executable rpm; then
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
      sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
      if is-executable dnf; then
        sudo dnf check-update
        sudo dnf install code
      elif is-executable yum; then
        sudo yum --assumeyes check-update
        sudo yum --assumeyes install code
      else
        echo "Hmmm - rpm is available, but dnf and yum aren't. What the heck, bro?"
      fi
    fi
  else
    echo "Man, you're on a Mac! Download and install it yerself, fool!"
  fi
else
  echo "Looks like Visual Studio Code's already installed. Try running an update, bro!"
fi

if is-executable code; then
  echo "Installing Visual Studio Code extensions."
  # Install extensions
  source ./vscode-exentions.sh
fi
