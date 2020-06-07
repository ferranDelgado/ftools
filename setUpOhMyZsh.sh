#!/bin/bash
source basic.sh


eco "Setting up custom folder"				
curDir=$(pwd)
path="$curDir/foh-my-zsh"

line=$(grep -n ZSH_CUSTOM= ~/.zshrc | grep "#" | awk -F ":" '{print $1}' | head -n 1)
line=$((line+1))
sed -i "$line i\ZSH_CUSTOM=$path" ~/.zshrc

eco "Setting up custom plugins"				
line=$(grep -n plugins= ~/.zshrc | grep -v "#" | awk -F ":" '{print $1}' | head -n 1)
sed -i "$line s/)/ ftool)/g" ~/.zshrc
