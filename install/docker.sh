#!/usr/bin/env bash
source ../shell/.function

# Make sure all dockers are removed.
sudo apt remove docker docker.io docker-ce
sudo apt autoremove

# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce
sudo apt-get update
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   edge"
sudo apt-get update
sudo apt-get install docker-ce

# https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
sudo groupadd docker
sudo usermod -aG docker $USER

# Docker Compose
# See: https://docs.docker.com/compose/install/#install-compose
TMPLATEST=$(mktemp)
wget -q https://github.com/docker/compose/releases/latest -O ${TMPLATEST}
GITHUB_URL=`cat ${TMPLATEST} | grep -o -E 'href="([^"#]+)docker-compose-Linux-x86_64"' | cut -d'"' -f2 | sort | uniq`
GITHUB_VERSION=`echo ${GITHUB_URL} | cut -d"/" -f6`
sudo wget --progress=bar -q https://github.com${GITHUB_URL} -O /usr/local/bin/docker-compose -q --show-      progress
sudo chmod +x /usr/local/bin/docker-compose
