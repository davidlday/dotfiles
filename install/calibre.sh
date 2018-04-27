#!/usr/bin/env bash
source ../shell/.function

if ! is-macos; then
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
else
    echo "For Mac, download the binary from https://calibre-ebook.com/dist/osx"
fi
