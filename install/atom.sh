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

if ! is-macos; then
  # Get installed version
  if is-executable atom; then
    # https://gist.github.com/maxrimue/ca69ee78081645e1ef62
    INSTALLED_VERSION=$(atom --version | grep Atom | cut -d":" -f2 | xargs)
  else
    INSTALLED_VERSION="0.0.0"
  fi

  ATOM_LATEST=$(mktemp /tmp/atom-latest-XXXXXXXX)
  wget -q https://github.com/atom/atom/releases/latest -O "$ATOM_LATEST"
  GITHUB_URL=$(< "$ATOM_LATEST" grep -o -E 'href="([^"#]+)atom-amd64.deb"' | cut -d'"' -f2 | sort | uniq)
  GITHUB_VERSION=$(echo "$GITHUB_URL" | cut -d"/" -f6)
  GITHUB_VERSION="${GITHUB_VERSION//v/}"
  rm -rf "$ATOM_LATEST"

  echo "Installed version: '$INSTALLED_VERSION'"
  echo "GitHub version: '$GITHUB_VERSION'"

  if [ "$INSTALLED_VERSION" != "$GITHUB_VERSION" ]; then
    echo "Installing latest version from https://github.com$GITHUB_URL"
    wget --progress=bar -q "https://github.com$GITHUB_URL" -O /tmp/atom-amd64.deb
    sudo dpkg -i /tmp/atom-amd64.deb
    rm /tmp/atom-amd64.deb
  else
    echo "Atom is up-to-date. Nothing to do."
  fi
else
  echo "Man, you're on Mac! Atom updates automatically."
fi

if is-executable apm; then
  echo "Installing Atom packages."
  declare -a packages=(
    atom-focus-mode
    atom-beautify
    atom-trello
    busy-signal
    editorconfig
    file-icons
    git-plus
    intentions
    linter
    linter-languagetool
    linter-shellcheck
    linter-ui-default
    linter-write-good
    open-terminal-here
    wordcount
  )

  for package in "${packages[@]}"; do
    if ls "$HOME/.atom/packages" | grep "$package" >/dev/null 2>&1; then
      echo "$package already installed."
    else
      apm install "$package"
    fi
  done

fi

echo "Atom installation done."
