#!/usr/bin/env bash
# See: https://askubuntu.com/questions/967517/backup-gnome-terminal
source ../shell/.function

if ! is-macos; then
  DCONF="$(command -v dconf)"
  GNOME_TERMINAL_SETTINGS="$(realpath ../gnome-terminal/gnome_terminal_profile.txt)"
  echo "Resetting gnome terminal settings!"
  "$DCONF" reset -f /org/gnome/terminal/
  echo "Importing $GNOME_TERMINAL_SETTINGS..."
  "$DCONF" load /org/gnome/terminal/ < "$GNOME_TERMINAL_SETTINGS"
  echo "Done!"
else
  echo "Man, you're on Mac! There's no Gnome Terminal! Import your Terminal settings manually."
fi
