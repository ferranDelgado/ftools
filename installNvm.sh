#!/bin/bash
#Source: https://github.com/nodesource/distributions/blob/master/README.md
source basic.sh

# Using Ubuntu
NVM_VERSION="v0.40.3"
info "Installing nvm version $NVM_VERSION"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
