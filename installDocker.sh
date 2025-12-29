#!/bin/bash

source basic.sh

eco "-> This script will install Docker <-"
eco " Please take a look to this link and make sure the script is up to date."
eco " https://docs.docker.com/engine/install/ubuntu/ "
read -p "Press enter to continue"

sudo apt-get remove docker docker-engine docker.io containerd runc

eco "Old dockers uninstalled"


eco "1. Update the apt package index and install packages to allow apt to use a repository over HTTPS:"
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common



eco "2. Add Docker’s official GPG key:"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

eco "Set up the docker stable repository"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

eco "Installing Docker"


sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

eco "Verify that Docker Engine is installed correctly by running the hello-world image."
eco "$ sudo docker run hello-world"



eco "---> Adding Docker group"

#!/usr/bin/env bash
set -euo pipefail

# Updated Docker installer (non-interactive) following current Docker docs
# - Stores Docker GPG key under /usr/share/keyrings
# - Uses `signed-by` in sources.list.d entry (apt-key is deprecated)
# - Installs non-interactively and enables the service

source basic.sh || true

info "Installing Docker (non-interactive, following Docker docs)..."

# Remove old packages if present (safe - ignore errors)
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

info "Updating apt and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

info "Adding Docker GPG key to /usr/share/keyrings..."
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

info "Adding Docker apt repository (signed-by the keyring)..."
ARCH=$(dpkg --print-architecture)
CODENAME=$(lsb_release -cs)
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

info "Installing Docker packages..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

info "Enabling and starting Docker service..."
sudo systemctl enable --now docker

info "Configuring docker group for current user..."
if ! getent group docker >/dev/null; then
    sudo groupadd docker || true
fi
sudo usermod -aG docker "${USER}"
newgrp docker
info "Installed Docker: $(docker --version || true)"

info "Checking whether the current session has docker group membership..."
if id -nG "${USER}" | grep -qw docker; then
    info "User '${USER}' is in the 'docker' group for this session. Trying to run hello-world..."
    if docker run --rm hello-world >/dev/null 2>&1; then
        info "hello-world ran successfully as '${USER}'."
    else
        warning "User is in docker group but 'hello-world' failed. Check Docker service logs: 'sudo journalctl -u docker -n 50'"
    fi
else
    warning "User '${USER}' is not in the 'docker' group for this session (group membership was just changed)."
    info "Trying to run hello-world using sudo to verify the daemon is healthy..."
    if sudo docker run --rm hello-world >/dev/null 2>&1; then
        info "hello-world ran successfully with sudo — the Docker daemon is working." 
        warning "To use Docker as '${USER}' without sudo, log out and log back in, or run: 'newgrp docker' in this shell."
    else
        error "Even 'sudo docker run' failed — check Docker service status with: 'sudo systemctl status docker' and view logs: 'sudo journalctl -u docker -n 200'."
    fi
fi

info "Done. If docker commands still require sudo after re-login, re-check group membership: 'id -nG'"

