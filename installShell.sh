#!/bin/bash
curDir="$(pwd)"

function checkSuccess() {

	if [ $? -ne 0 ]; then
		echo "Last command hasn't success"
		exit 1
	fi

}

function eco() {
	echo "]>> $1"
}

function createRcScript() {
	eco "Creating .zshrc file"				
	local curDir=$(pwd)
	local path="$curDir/foh-my-zsh"
	sed -i '10 i\ZSH_CUSTOM=$path' ~/.zshrc

	local line=$(grep -n plugins= .zshrc | grep -v "#" | awk -F ":" '{print $1}' | head -n 1)
	sed -i '$line i\plugins=(ftools)' ~/.zshrc

	checkSuccess

}

eco "Installing curl"
sudo apt-get install curl

eco "Installing Zsh ..."
sudo apt-get install zsh

checkSuccess

chsh -s $(which zsh)

eco "Zsh Installed $(zsh --version)"

eco "Installing Oh my zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

eco "Zsh and Oh my shell installed"
eco "Reboot terminal or run source ~/.zshrc"

