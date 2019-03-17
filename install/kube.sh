#!/usr/bin/env bash
source ../shell/.function

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
