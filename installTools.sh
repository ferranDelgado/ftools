#!/bin/bash
source basic.sh

function installBasics() {
	tools=(terminator vim unzip zip)

	for i in ${tools[@]}; do
		echo "install ${i}"
		sudo apt-get install $i
	done


	echo "Config git lg alias"

	git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
	git config --global core.editor "vim"

}


installBasics

eco "Set tmux conf"

if [[ -L ~/.tmux.conf ]]; then
	echo "-------------- .tmux does not exists"
	mv ~/.tmux.conf ~/.tmux.conf.copy
fi

ln -s $(pwd)/f-tmux.conf ~/.tmux.conf


if [ -z "$(command -v sdk)"  ]; then
	eco "Sdk man is already installed"
else 
	eco "Installing Sdk Man"
	curl -s "https://get.sdkman.io" | bash
fi

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
