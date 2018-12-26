#!/bin/bash
#Source: https://github.com/nodesource/distributions/blob/master/README.md
source basic.sh

# Using Ubuntu
eco "Installing Node 10.x"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
