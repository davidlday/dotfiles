#!/usr/bin/env bash
source ../shell/.function

if ! is-macos; then
  # https://linuxconfig.org/how-to-install-docker-on-ubuntu-18-04-bionic-beaver
  # Stable not yet available

  # TODO: Package detection and upgrade. Make idempotent.
  # See: https://stackoverflow.com/questions/1298066/check-if-a-package-is-installed-and-then-install-it-if-its-not#1298103

  # https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce
  # Make sure all dockers are removed.
  sudo apt remove docker docker-engine docker.io
  sudo apt autoremove

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
    stable edge"
  sudo apt-get update
  sudo apt-get install docker-ce

  # https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
  sudo groupadd docker
  sudo usermod -aG docker "$USER"

  # Docker Compose
  # See: https://docs.docker.com/compose/install/#install-compose
  # Get installed version
  if is-executable docker-compose; then
    # https://gist.github.com/maxrimue/ca69ee78081645e1ef62
    INSTALLED_VERSION=$(docker-compose --version | cut -d " " -f3)
    INSTALLED_VERSION="${INSTALLED_VERSION//,/}"
  else
    INSTALLED_VERSION="0.0.0"
  fi
  COMPOSE_LATEST=$(mktemp /tmp/docker-compose-latest-XXXXXXXX)
  wget -q https://github.com/docker/compose/releases/latest -O "$COMPOSE_LATEST"
  GITHUB_URL=$(< "$COMPOSE_LATEST" grep -o -E 'href="([^"#]+)docker-compose-Linux-x86_64"' | cut -d'"' -f2 | sort | uniq)
  GITHUB_VERSION=$(< "$GITHUB_URL" cut -d"/" -f6)

  ret=$(version_compare "$INSTALLED_VERSION" "$GITHUB_VERSION")
  if [ "${ret}" == "-1" ]; then
    sudo wget --progress=bar -q "https://github.com$GITHUB_URL" -O /usr/local/bin/docker-compose -q --show-      progress
    sudo chmod +x /usr/local/bin/docker-compose
  else
    echo "Docker-compose is up to date. Nothing to do."
  fi

else
  echo "Man, you're on a Mac! Use the docker installer."
fi
