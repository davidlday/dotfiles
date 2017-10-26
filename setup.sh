#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
DOTFILES_EXTRA_DIR="$HOME/.extra"

# Common functions

. "$DOTFILES_DIR/shell/.function"

# Update dotfiles itself first

if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

# Ensure directories exists
mkdir -p ~/.pip/

# TODO: Need to link right things in the right places.
# See: https://superuser.com/questions/703415/why-do-people-source-bash-profile-from-bashrc-instead-of-the-other-way-round
# I use MacOS, Ubuntu, and Fedora.

# Bunch of symlinks
ln -sfv "$DOTFILES_DIR/bash/.bashrc" ~
ln -sfv "$DOTFILES_DIR/bash/.inputrc" ~
ln -sfv "$DOTFILES_DIR/gem/.gemrc" ~
ln -sfv "$DOTFILES_DIR/vim/.vimrc" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
ln -sfv "$DOTFILES_DIR/pip/pip.conf" ~/.pip/pip.conf

# Package managers & packages
# My preference is to manually install things I need when I need them.

# . "$DOTFILES_DIR/install/brew.sh"

# Run tests

if is-executable bats; then bats test/*.bats; else echo "Skipped: tests (missing: bats)"; fi

# Install extra stuff

if [ -d "$DOTFILES_EXTRA_DIR" -a -f "$DOTFILES_EXTRA_DIR/install.sh" ]; then
  . "$DOTFILES_EXTRA_DIR/install.sh"
fi
