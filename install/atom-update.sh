#!/usr/bin/env bash
# https://askubuntu.com/questions/589469/how-to-automatically-update-atom-editor#630530
# if  [[ $EUID > 0 ]]
#   then echo "Please run as root"
#   exit
# fi
wget -q https://github.com/atom/atom/releases/latest -O /tmp/latest
export GITHUB_URL=`cat /tmp/latest | grep -o -E 'href="([^"#]+)atom-amd64.deb"' | cut -d'"' -f2 | sort | uniq`
export GITHUB_VERSION=`echo ${GITHUB_URL} | cut -d"/" -f6`
export INSTALLED_VERSION=`atom --version | grep Atom | cut -d":" -f2`
wget --progress=bar -q https://github.com${GITHUB_URL} -O /tmp/atom-amd64.deb -q --show-      progress
gnome-software --local-filename=/tmp/atom-amd64.deb

#wget --progress=bar -q 'https://github.com'$(cat /tmp/latest | grep -o -E 'href="([^"#]+)atom-amd64.deb"' | cut -d'"' -f2 | sort | uniq) -O /tmp/atom-amd64.deb -q --show-      progress
# dpkg -i /tmp/atom-amd64.deb
