#!/usr/bin/env bash
set -euo pipefail

echo "==> Removing legacy Docker packages..."
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)

echo "==> Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

echo "==> Adding Docker official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "==> Setting up Docker repository..."
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "==> Installing Docker Engine and Plugins..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Starting and enabling Docker service..."
sudo systemctl enable --now docker

echo "==> Managing user permissions..."
if ! getent group docker >/dev/null; then
    sudo groupadd docker
fi

sudo usermod -aG docker "$USER"

echo "==> Verifying installation..."
sudo docker run --rm hello-world

echo "-------------------------------------------------------------------"
echo "Installation complete!"
echo "To run Docker without 'sudo', please log out and log back in."
echo "-------------------------------------------------------------------"