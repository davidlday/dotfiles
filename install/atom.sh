#!/usr/bin/env bash
source ../shell/.function

# Get installed version
if is-executable atom; then
  # https://gist.github.com/maxrimue/ca69ee78081645e1ef62
  INSTALLED_VERSION=$(atom --version | grep Atom | cut -d":" -f2)
  INSTALLED_VERSION=${INSTALLED_VERSION//./}
else
  INSTALLED_VERSION="0.0.0"
fi

INSTALLED_MAJOR=$(echo ${INSTALLED_VERSION} | awk '{print $1}')
INSTALLED_MINOR=$(echo ${INSTALLED_VERSION} | awk '{print $2}')
INSTALLED_PATCH=$(echo ${INSTALLED_VERSION} | awk '{print $3}')

wget -q https://github.com/atom/atom/releases/latest -O /tmp/latest
GITHUB_URL=`cat /tmp/latest | grep -o -E 'href="([^"#]+)atom-amd64.deb"' | cut -d'"' -f2 | sort | uniq`
GITHUB_VERSION=`echo ${GITHUB_URL} | cut -d"/" -f6`
# TODO: Test INSTALLED_VERSION against GITHUB_VERSION
wget --progress=bar -q https://github.com${GITHUB_URL} -O /tmp/atom-amd64.deb -q --show-      progress
gnome-software --local-filename=/tmp/atom-amd64.deb
