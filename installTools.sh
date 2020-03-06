#!/bin/bash
source basic.sh

function command_exists () {
    type "$1" &> /dev/null ;
}

function installBasics() {
	tools=(terminator vim unzip zip tmux)

	for i in ${tools[@]}; do
		if command_exists $i ; then
        		eco "${i} is already installed"
		else
			eco "install ${i}"
			sudo apt-get install $i
		fi
	done


	eco "Config git lg alias"

	git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
	git config --global core.editor "vim"

}


installBasics

if command_exists ; then
	eco "Set tmux conf"

	if [[ -L ~/.tmux.conf ]]; then
		echo "-------------- .tmux does not exists"
		mv ~/.tmux.conf ~/.tmux.conf.copy
	fi

	ln -s $(pwd)/f-tmux.conf ~/.tmux.conf
fi

if [ -d "$HOME/.sdkman" ]  ; then
	eco "Sdk man is already installed"
else
	eco "Installing Sdk Man"
	curl -s "https://get.sdkman.io" | bash
	source "$HOME/.sdkman/bin/sdkman-init.sh"
	sdk version
fi

