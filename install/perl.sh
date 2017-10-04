#!/usr/bin/env bash
source ../shell/.function

# TODO: Consider switching to plenv: https://github.com/tokuhirom/plenv

# Works on MacOS and Linux
if is-executable curl; then
  \curl -L https://install.perlbrew.pl | bash
else
  \wget -O - https://install.perlbrew.pl | bash
fi
