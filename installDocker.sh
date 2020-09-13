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

sudo groupadd docker

sudo usermod -aG docker $USER

newgrp docker 

eco "Verify that you can run docker commands without sudo."
eco "docker run hello-world"

