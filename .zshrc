# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM=$HOME/zsh_customizations
ZSH_THEME="robbyrussell"
plugins=(
  git
  ftools
)

# Load custom functions
fpath=($fpath ~/.zsh)

# Load OMZ
source $ZSH/oh-my-zsh.sh

# Default to vim
export EDITOR=vim

export PATH="/home/ferran/.local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin


# set_prompt


export GOROOT=/usr/local/go #gosetup
export GOPATH=/home/ferran/go #gosetup

PATH="/home/ferran/dev/go/bin:$PATH"
export ANDROID_HOME=/home/ferran/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Go configuration added by installGo.sh
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
