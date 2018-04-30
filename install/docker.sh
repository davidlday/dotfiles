#!/usr/bin/env bash
source ../.function

# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce
sudo apt-get update
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-get install docker-ce

# https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
sudo groupadd docker
sudo usermod -aG docker $USER

