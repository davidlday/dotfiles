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

# Install kubernetes-cli and kube-ps1
if can-brew; then
  brew install kubernetes-cli kube-ps1
fi

# Install minikube
export MINIKUBE_BINARY
mkdir -p "$HOME/.local/opt/minikube"
if is-macos; then
  MINIKUBE_BINARY="minikube-darwin-amd64"
else
  MINIKUBE_BINARY="minikube-linux-amd64"
fi
curl --location "https://storage.googleapis.com/minikube/releases/latest/$MINIKUBE_BINARY" \
  --output "$HOME/.local/opt/minikube/minikube"
chmod u+x "$HOME/.local/opt/minikube/minikube"
ln -svf "$HOME/.local/opt/minikube/minikube" "$HOME/.local/bin/minikube"
