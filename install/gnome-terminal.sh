#!/usr/bin/env bash
# See: https://askubuntu.com/questions/967517/backup-gnome-terminal

# Not strictly necessary, but left over from old readlink/greadlink.
REALPATH=$(command -v realpath)

# Find current script source, if possible
CURRENT_SCRIPT="${BASH_SOURCE[0]}"

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without realpath and/or $BASH_SOURCE/$0)
if [[ -n "$CURRENT_SCRIPT" && -x "$REALPATH" ]]; then
  SCRIPT_PATH=$($REALPATH "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

if ! is-macos; then
  DCONF="$(command -v dconf)"
  GNOME_TERMINAL_SETTINGS="$(realpath "$DOTFILES_DIR/gnome-terminal/gnome_terminal_profile.txt")"
  echo "Resetting gnome terminal settings!"
  "$DCONF" reset -f /org/gnome/terminal/
  echo "Importing $GNOME_TERMINAL_SETTINGS..."
  "$DCONF" load /org/gnome/terminal/ < "$GNOME_TERMINAL_SETTINGS"
  echo "Done!"
else
  echo "Man, you're on Mac! There's no Gnome Terminal! Import your Terminal settings manually."
fi
