# fTools
List of scripts that I use to set up my workstation. 
Some of the scripts might be not updated and they need some improvements, but they are useful for me to speedup everytime I have to set up a new machine.


## Install essentials 
Execute the following script to install the essentials to start
```bash
bash <(wget -qO- https://raw.githubusercontent.com/ferranDelgado/ftools/refs/heads/main/install_essentials.sh)
```

This will install
- zsh
- OhMyZsh
- Essential tools `curl`, `vim`, `git`, `htop`, `unzip`, `zsh` and `terminator`
- Setup ssh keys

## Alias

- **bigFiles**: show the 10 biggest files and folders
