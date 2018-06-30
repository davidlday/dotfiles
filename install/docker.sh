#!/usr/bin/env bash

# Not strictly necessary, but left over from old readlink/greadlink.
REALPATH=$(command -v realpath)

# Find current script source, if possible
CURRENT_SCRIPT="${BASH_SOURCE[0]}"

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without realpath and/or $BASH_SOURCE/$0)
if [[ -n "$CURRENT_SCRIPT" && -x "$REALPATH" ]]; then
  SCRIPT_PATH=$($REALPATH "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Source functions, assuming they're not already
# shellcheck source=/dev/null
source "$DOTFILES_DIR/shell/.function"

if ! is-macos; then
  echo "Installing Docker CE & Docker Compose."
  if can-apt; then
    if dpkg-query --status docker-ce >/dev/null 2>&1; then
      echo "Docker CE already installed. Running update / upgrade."
      sudo apt update
      sudo apt upgrade -y
    else
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
    fi
  elif can-yum; then
    if rpmquery docker-ce >/dev/null; then
      echo "Docker CE already installed. Running update / upgrade."
      sudo yum update
      sudo yum upgrade --assumeyes
    else
      # https://docs.docker.com/install/linux/docker-ce/centos/#uninstall-old-versions
      # Make sure all old dockers are removed
      sudo yum remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine

      # https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository
      # Install dependencies
      sudo yum update
      sudo yum install --assumeyes yum-utils \
        device-mapper-persistent-data \
        lvm2
      # Set up the repository
      sudo yum-config-manager --assumeyes \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
      # Install docker-ce
      sudo yum update
      sudo yum install --assumeyes docker-ce
    fi
  fi

  # Start the service
  sudo systemctl start docker
  sudo systemctl enable docker

  # https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
  sudo groupadd docker
  sudo usermod -aG docker "$USER"

  echo "Docker CE installed. You likely have to log out and back in for your group settings to take effect."

  # Docker Compose
  # See: https://docs.docker.com/compose/install/#install-compose
  # Get installed version
  echo "Checking docker-compose."
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
  GITHUB_VERSION=$(echo "$GITHUB_URL" | cut -d"/" -f6)

  ret=$(version_compare "$INSTALLED_VERSION" "$GITHUB_VERSION")
  if [ "${ret}" == "-1" ]; then
    echo "Installing docker-compose."
    sudo wget --progress=bar -q "https://github.com$GITHUB_URL" -O /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker-compose installed."
  else
    echo "Docker-compose is up to date. Nothing to do."
  fi

  echo "Docker CE & Docker Compose done."
else
  echo "Man, you're on a Mac! Use the docker installer."
fi
