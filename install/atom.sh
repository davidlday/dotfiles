#!/usr/bin/env bash
source ../shell/.function

# Get installed version
if is-executable atom; then
  # https://gist.github.com/maxrimue/ca69ee78081645e1ef62
  INSTALLED_VERSION=$(atom --version | grep Atom | cut -d":" -f2)
else
  INSTALLED_VERSION="0.0.0"
fi

wget -q https://github.com/atom/atom/releases/latest -O /tmp/latest
GITHUB_URL=`cat /tmp/latest | grep -o -E 'href="([^"#]+)atom-amd64.deb"' | cut -d'"' -f2 | sort | uniq`
GITHUB_VERSION=`echo ${GITHUB_URL} | cut -d"/" -f6`
GITHUB_VERSION=${GITHUB_VERSION//v/}

echo "Installed version: ${INSTALLED_VERSION}"
echo "GitHub version: ${GITHUB_VERSION}"

ret=$(version_compare ${INSTALLED_VERSION} ${GITHUB_VERSION})
if [ "${ret}" == "-1" ]; then
  echo "Installing latest version."
  wget --progress=bar -q https://github.com${GITHUB_URL} -O /tmp/atom-amd64.deb -q --show-      progress
  gnome-software --local-filename=/tmp/atom-amd64.deb
else
  echo "Atom is up-to-date. Nothing to do."
fi
