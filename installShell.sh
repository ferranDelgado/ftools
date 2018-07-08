#!/bin/bash
curDir="$(pwd)"

function checkSuccess() {
	if [ $? -ne 0 ]; then
		echo "Last command hasn't success"
	fi

}

function eco() {
	echo "]>> $1"
}

function createRcScript() {
	eco "Creating .zshrc file"				
	local curDir=$(pwd)
	local path="$curDir/foh-my-zsh"
	sed -E "s@__CUSTOM_ZSH_PATH__@$path@g" f-zshrc-template  > f-zshrc
	checkSuccess
	rm -f ~/.zshrc
	ln -s $curDir/f-zshrc ~/.zshrc
	eco ".zshrc file created"

}

eco "Installing Zsh ..."
sudo apt-get install zsh

checkSuccess

chsh -s $(which zsh)

eco "Zsh Installed $(zsh --version)"

eco "Installing Oh my zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

createRcScript

eco "Zsh and Oh my shell installed"
eco "Reboot terminal or run source ~/.zshrc"

