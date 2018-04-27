#!/usr/bin/env bash
source ../shell/.function

# Get installed version
if is-executable atom; then
    export INSTALLED_VERSION=`atom --version | grep Atom | cut -d":" -f2`
else
    INSTALLED_VERSION="0.0.0"
fi

wget -q https://github.com/atom/atom/releases/latest -O /tmp/latest
export GITHUB_URL=`cat /tmp/latest | grep -o -E 'href="([^"#]+)atom-amd64.deb"' | cut -d'"' -f2 | sort | uniq`
export GITHUB_VERSION=`echo ${GITHUB_URL} | cut -d"/" -f6`
# TODO: Test INSTALLED_VERSION against GITHUB_VERSION
wget --progress=bar -q https://github.com${GITHUB_URL} -O /tmp/atom-amd64.deb -q --show-      progress
gnome-software --local-filename=/tmp/atom-amd64.deb
