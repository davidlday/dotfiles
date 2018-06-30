#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR DOTFILES_CACHE DOTFILES_LOCAL_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
DOTFILES_LOCAL_DIR="$HOME/.local/dotfiles"

# Common functions
# shellcheck source=/dev/null
source "$DOTFILES_DIR/shell/.function"

# Update dotfiles itself first
if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

# Ensure directories exists
mkdir -p "$HOME/.pip/" "$HOME/.atom/"

# TODO: Need to link right things in the right places.
# See: https://superuser.com/questions/703415/why-do-people-source-bash-profile-from-bashrc-instead-of-the-other-way-round
# I use MacOS, Ubuntu, and Fedora.

# Bunch of symlinks
ln -sfv "$DOTFILES_DIR/bash/.bashrc" "$HOME"
ln -sfv "$DOTFILES_DIR/bash/.inputrc" "$HOME"
ln -sfv "$DOTFILES_DIR/gem/.gemrc" "$HOME"
ln -sfv "$DOTFILES_DIR/editorconfig/.editorconfig" "$HOME"
ln -sfv "$DOTFILES_DIR/vim/.vimrc" "$HOME"
ln -sfv "$DOTFILES_DIR/git/.gitconfig" "$HOME"
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" "$HOME"
ln -sfv "$DOTFILES_DIR/pip/pip.conf" "$HOME/.pip/pip.conf"
ln -sfv "$DOTFILES_DIR/pypi/.pypirc" "$HOME/.pypirc"
ln -sfv "$DOTFILES_DIR/atom/snippets.cson" "$HOME/.atom/snippets.cson"
ln -sfv "$DOTFILES_DIR/cookiecutter/.cookiecutterrc" "$HOME/.cookiecutterrc"

# Package managers & packages
# My preference is to manually install things I need when I need them.
# . "$DOTFILES_DIR/install/brew.sh"

# Run tests
if is-executable bats; then bats test/*.bats; else echo "Skipped: tests (missing: bats)"; fi

# Install extra stuff
if [ -d "$DOTFILES_LOCAL_DIR" ] && [ -f "$DOTFILES_LOCAL_DIR/install.sh" ]; then
  # shellcheck source=/dev/null
  source "$DOTFILES_LOCAL_DIR/install.sh"
fi

echo "Checking home directory for broken links. Take note..."
find "$HOME" -xtype l
echo "Setup complete."
