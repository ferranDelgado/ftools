#!/bin/bash
source basic.sh

info "Configuring Git user name and email in global config"

read -p "Name: " name
read -p "Email: " email

git config --global user.name $name
git config --global user.email $email

info "Git user name and email configured in global. Name: $name Email: $email"
