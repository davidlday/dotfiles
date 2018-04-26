#!/usr/bin/env bash

# Themes
sudo add-apt-repository ppa:noobslab/themes

# Etcher
echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | sudo tee /etc/apt/sources.list.d/etcher.list
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61

sudo apt-get update
sudo apt-get install etcher-electron