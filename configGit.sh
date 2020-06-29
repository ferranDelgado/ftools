#!/bin/bash
source basic.sh

eco "Configuring Git user name and email in global config"

read -p "Name: " name
read -p "Email: " email

git config --global user.name $name
git config --global user.email $email

eco "Git user name and email configured in global. Name: $name Email: $email"

eco "Setting pull --rebase by default"

git config --global pull.rebase true

eco "Config git lg alias"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

echo "Config git branch alias"
git config --global alias.b "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'""

git config --global core.editor "vim"
