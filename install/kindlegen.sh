#!/usr/bin/env bash
source ../shell/.function

if ! is-macos; then
    KGEN_LINK="http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz"
    TMPDIR=$(mktemp -d)

    wget --progress=bar -q ${KGEN_LINK} -O ${TMPDIR}/kindlegen_linux.tar.gz -q --show-      progress
    sudo mkdir -p /opt/KindleGen
    sudo tar --extract --verbose --gzip --file=${TMPDIR}/kindlegen_linux.tar.gz --directory=/opt/KindleGen 
    sudo chown -R root:root /opt/KindleGen
    sudo ln -svf /opt/KindleGen/kindlegen /usr/local/bin/kindlegen
#    rm -rf ${TMPDIR}
else
    # TODO: Add Mac install
    echo "Mac installer not supported yet."
fi