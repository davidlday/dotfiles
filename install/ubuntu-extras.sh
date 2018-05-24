#!/usr/bin/env bash
source ../shell/.function

# Etcher
echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | sudo tee /etc/apt/sources.list.d/etcher.list
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61

sudo apt-get update
sudo apt-get install etcher-electron arc-theme

# Restore GNOME Terminal settings
# https://askubuntu.com/questions/967517/backup-gnome-terminal
dconf load /org/gnome/terminal < ../gnome-terminal/gnome_terminal_profile.txt