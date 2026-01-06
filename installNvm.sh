#!/bin/bash
#Source: https://github.com/nodesource/distributions/blob/master/README.md
source basic.sh

# Using Ubuntu
NVM_VERSION="v0.40.3"
info "Installing nvm version $NVM_VERSION"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash

if [ -s "$HOME/.nvm/nvm.sh" ]; then
    source "$HOME/.nvm/nvm.sh"
else
    echo "Error: could not source './.zshrc' or '$HOME/.nvm/nvm.sh' - nvm is not available" >&2
    exit 1
fi
nvm install --lts

info "nvm installation complete, and node lts installed. (You may need to restart your terminal or run 'source ~/.zshrc' to start using nvm)"