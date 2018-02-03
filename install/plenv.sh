#!/usr/bin/env bash

# Install plenv
# https://github.com/tokuhirom/plenv
if is-macos; then
  # Use Homebrew on MacOS
  # https://github.com/tokuhirom/plenv#homebrew-on-mac-os-x
  brew install plenv
  brew install perl-build
else
  # The GitHub way
  [ ! -d ~/.plenv ] && git clone https://github.com/tokuhirom/plenv.git ~/.plenv
  # https://github.com/tokuhirom/Perl-Build
  [ ! -d ~/.plenv/plugins/perl-build/ ] && git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
fi
