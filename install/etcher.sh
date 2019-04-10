#!/usr/bin/env bash
source ../shell/.function

if ! is-macos; then
  if can-apt; then
    # clean out old etcher
    sudo apt -y remove etcher-electron
    sudo rm -rf /etc/apt/sources.list.d/etcher.list*
    # Add new etcher repo and install
    echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
    sudo apt update
    sudo apt -y install balena-etcher-electron
  elif is-executable rpm; then
    sudo wget https://balena.io/etcher/static/etcher-rpm.repo -O /etc/yum.repos.d/etcher-rpm.repo
    if can-dnf; then
      sudo dnf check-update
      sudo dnf install -y balena-etcher-electron
    elif can-yum; then
      sudo yum --assumeyes check-update
      sudo yum --assumeyes install balena-etcher-electron
    else
      echo "Hmmm - rpm is available, but dnf and yum aren't. What the heck, bro?"
    fi
  fi
else
  echo "Man, you're on a Mac! This is only for Linux."
fi
