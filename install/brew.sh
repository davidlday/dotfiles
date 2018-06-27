#!/usr/bin/env bash
source ../shell/.function

if ! can-brew; then
  if is-macos; then
    echo "Installing HomeBrew (https://brew.sh)"
    # See: https://brew.sh/
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    if can-sudo; then
      echo "Installing LinuxBrew (https://linuxbrew.sh)"
      if can-apt; then
        sudo apt-get --yes install build-essential curl file git python-setuptools ruby
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      elif can-dnf; then
        sudo dnf groupinstall 'Development Tools' && sudo dnf install curl file git
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      elif can-yum; then
        sudo yum groupinstall 'Development Tools' && sudo yum install curl file git
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      else
        echo "Dudo, you're not on a Mac and you can't apt, dnf, or yum. What the hell platform you on, bro?"
      fi
    else
      echo "Need sudo to install LinuxBrew, bro!"
    fi
  fi
else
  echo "Brew already installed. Running updates."
fi

source ../shell/.exports_brew

dedupe-path

brew update
brew upgrade

# Install coreutils on mac
if is-macos; then
  brew install \
    coreutils
fi

# Install good stuff on everything
brew install \
  bash-git-prompt \
  cookiecutter \
  curl \
  git \
  languagetool \
  maven \
  pandoc \
  python \
  python@2 \
  ruby \
  shellcheck \
  sqlite \
  travis \
  tree \
  vim

echo "Brew installation done."
