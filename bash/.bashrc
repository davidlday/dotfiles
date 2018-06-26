#!/usr/bin/env bash

# If not running interactively, don't do anything

[ -z "$PS1" ] && return

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

# Read cache

DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
# shellcheck source=/dev/null
[ -f "$DOTFILES_CACHE" ] && source "$DOTFILES_CACHE"

# Finally we can source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/shell/.{function,function_*,path,env,alias,completion,grep,exports_*,prompt,custom}; do
  # shellcheck source=/dev/null
  [ -f "$DOTFILE" ] && source "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/shell/.{env,alias,function}.macos; do
    # shellcheck source=/dev/null
    [ -f "$DOTFILE" ] && source "$DOTFILE"
  done
fi

# Set LSCOLORS
# TODO: Need to make dircolors work on MacOS via gdircolors.
if is-macos; then
  eval "$(gdircolors "$DOTFILES_DIR"/shell/.dircolors)"
else
  eval "$(dircolors "$DOTFILES_DIR"/shell/.dircolors)"
fi

# Hook for machine-specific files

DOTFILES_LOCAL_DIR="$HOME/.local/dotfiles"
if [ -d "$DOTFILES_LOCAL_DIR" ]; then
  for DOTFILE in "$DOTFILES_LOCAL_DIR"/shell/.{function,function_*,path,env,alias,completion,grep,prompt,exports_*,custom}; do
    # shellcheck source=/dev/null
    [ -f "$DOTFILE" ] && source "$DOTFILE"
  done
fi

# Clean up

unset REALPATH CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# Export

export DOTFILES_DIR DOTFILES_LOCAL_DIR
