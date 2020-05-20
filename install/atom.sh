#!/usr/bin/env bash
source ../shell/.function

if ! is-executable atom; then
  if ! is-macos; then
    if can-apt; then
      curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
      sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
      sudo apt-get update
      sudo apt-get install atom
    elif is-executable rpm; then
      sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
      sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/yum.repos.d/atom.repo'
      if can-dnf; then
        sudo dnf check-update
        sudo dnf install atom
      elif can-yum; then
        sudo yum --assumeyes check-update
        sudo yum --assumeyes install atom
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
  echo "Looks like Atom's already installed. Try running an update, bro!"
fi

if is-executable apm; then
  echo "Installing Atom packages."
  apm install --packages-file ../atom/package.list
fi

echo "Atom installation done."
