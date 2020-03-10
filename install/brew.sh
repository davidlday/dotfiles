#!/usr/bin/env bash
source ../shell/.function

# Install Linux/HomeBrew depending on platform
if ! can-brew; then
  if is-macos; then
    echo "Installing HomeBrew (https://brew.sh)"
    # See: https://brew.sh/
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    if can-sudo; then
      echo "Installing LinuxBrew (https://linuxbrew.sh)"
      if can-apt; then
        # Dependencies for brew
        sudo apt-get --yes install build-essential curl file git python-setuptools ruby
        # Dependencies for pyenv
        sudo apt-get --yes install make build-essential libssl-dev zlib1g-dev libbz2-dev \
          libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
          xz-utils tk-dev libffi-dev
        # Ready to install
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      elif can-dnf; then
        # Dependencies for brew
        sudo dnf -y groupinstall 'Development Tools' && sudo dnf -y install curl file git
        # Dependencies for pyenv
        sudo dnf -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel
        # Ready to install
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      elif can-yum; then
        # Dependencies for brew
        sudo yum -y groupinstall 'Development Tools' && sudo yum -y install curl file git
        # Dependencies for pyenv
        sudo yum -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel
        # Ready to install
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      else
        echo "Dude, you're not on a Mac and you can't apt, dnf, or yum. What the hell platform you on, bro?"
        exit 1
      fi
      echo "LinuxBrew installed."
    else
      echo "Need sudo to install LinuxBrew, bro!"
    fi
  fi
else
  echo "Brew already installed. Running updates."
fi

# shellcheck source=/dev/null
source "$DOTFILES_DIR/shell/.path"

dedupe-path

echo "Updating brew... may take a minute or so."
brew update
brew upgrade

# Install Mac-specific needs
if is-macos; then
  brew install \
    bash \
    bash-completion@2 \
    coreutils \
    smartmontools \
    ssh-copy-id

  # Linux (Ubuntu, CentOS) have 4.x versions of bash.
  # OSX still has a 3.x version of bash.
  # We'll use brewed bash on OSX.
  BREW_BASH="$(brew --prefix)/bin/bash"
  if is-executable "$BREW_BASH"; then
    if ! grep "$BREW_BASH" /etc/shells; then
      echo "Adding $BREW_BASH to /etc/shells."
      sudo sh -c "echo $BREW_BASH >> /etc/shells"
    fi
    if [ "$SHELL" -ne "$BREW_BASH" ]; then
      echo "Changing shell for $USER to $BREW_BASH"
      chsh -s "$BREW_BASH"
      echo "Shell updated: You will need to log out and back in."
    fi
  fi
  unset BREW_BASH

fi

# Install good stuff on everything
brew install \
  bash-git-prompt \
  cookiecutter \
  curl \
  direnv \
  git \
  goenv \
  languagetool \
  maven \
  pandoc \
  plenv \
  pyenv \
  pyenv-virtualenv \
  rbenv \
  shellcheck \
  starship \
  sqlite \
  travis \
  tree \
  wget \
  vim

echo "Brew installation done."
