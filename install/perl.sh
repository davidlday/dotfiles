#!/usr/bin/env bash
source ../shell/.function

# TODO: Consider switching to plenv: https://github.com/tokuhirom/plenv

# plenv
if is-macos; then
  if can-brew; then
    brew update
    brew install plenv
    brew install perl-build
  else
    echo "Skipped: plenv"
  fi
elif
  if is-executable git; then
    git clone https://github.com/tokuhirom/plenv.git ~/.plenv
    git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
    plenv ~/.plenv/bin/rehash
  else
    echo "Skipped: plenv"
  fi
fi

# Perlbrew.pl
if is-executable curl; then
  \curl -L https://install.perlbrew.pl | bash
else
  \wget -O - https://install.perlbrew.pl | bash
fi
