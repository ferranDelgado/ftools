#!/bin/bash
source basic.sh

eco "Installing latest Libre Office" 
sudo add-apt-repository ppa:libreoffice/ppa -y
sudo apt-get update
sudo apt-get install libreoffice
eco "Llibre office" && apt-cache policy libreoffice | grep "Installed\|Candidate" | awk '{print ">>" $0}'
