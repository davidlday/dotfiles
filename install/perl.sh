#!/usr/bin/env bash
source ../shell/.function

# plenv
if can-brew; then
  brew install plenv
  # perl-build broken in linuxbrew
  # brew install perl-build
  # Recommended way to install anyhow:
  # https://github.com/tokuhirom/Perl-Build
  git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
else
  echo "Skipped: plenv. Install brew first (brew.sh)."
fi
