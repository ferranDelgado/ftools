#!/bin/bash

set -euo pipefail

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

# --- 1. The Essentials List ---
APPS=("curl" "vim" "git" "htop" "unzip" "zsh" "terminator")

# --- 2. Identity Configuration Check ---
USER_EMAIL=$(git config --global user.email)
if [ -z "$USER_EMAIL" ]; then
    printf "${BLUE}==>${NC} Enter the email for GitHub: "
    read USER_EMAIL < /dev/tty
    git config --global user.email "$USER_EMAIL"
else
    printf "${GREEN}✔ Using existing Git email: ${NC}%s\n" "$USER_EMAIL"
fi

USER_NAME=$(git config --global user.name)
if [ -z "$USER_NAME" ]; then
    printf "${BLUE}==>${NC} Enter your name for Git: "
    read USER_NAME < /dev/tty
    git config --global user.name "$USER_NAME"
else
    printf "${GREEN}✔ Using existing Git name: ${NC}%s\n" "$USER_NAME"
fi

# Check for WORKSPACE env var
if [ -n "$WORKSPACE" ]; then
    CLONE_DIR="$WORKSPACE"
    printf "${GREEN}✔ Using WORKSPACE environment variable: ${NC}%s\n" "$CLONE_DIR"
else
    printf "${BLUE}==>${NC} Enter clone directory (default: ~/workspace): "
    read INPUT_DIR < /dev/tty
    CLONE_DIR=${INPUT_DIR:-~/workspace}
fi

# --- 3. Bootstrap Essentials ---
printf "${YELLOW}Checking system dependencies...${NC}\n"

if [ -f /etc/debian_version ]; then
    PM="sudo DEBIAN_FRONTEND=noninteractive apt-get"
    UPDATER="sudo apt-get update -qq"
elif [ -f /etc/fedora-release ]; then
    PM="sudo dnf"
    UPDATER="sudo dnf check-update"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PM="brew"
    UPDATER="brew update"
else
    printf "${RED}Error: OS not supported for automatic installation.${NC}\n"
    exit 1
fi

printf "${BLUE}Updating package lists...${NC}\n"
$UPDATER

for app in "${APPS[@]}"; do
    if ! command -v "$app" &> /dev/null; then
        printf "${YELLOW}Installing %s...${NC}\n" "$app"
        $PM install -y "$app" > /dev/null
    else
        printf "${GREEN}✔ %s is already installed.${NC}\n" "$app"
    fi
done

# --- 4. Oh My Zsh Installation ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    printf "${YELLOW}Installing Oh My Zsh...${NC}\n"
    # RUNZSH=no prevents it from opening a new shell and killing this script
    # CHSH=no prevents it from asking for password to change shell (we do it later)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    printf "${GREEN}✔ Oh My Zsh is already installed.${NC}\n"
fi

# --- 5. Generate SSH Key ---
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY_PATH" ]; then
    printf "${YELLOW}Generating Ed25519 SSH key...${NC}\n"
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$SSH_KEY_PATH" -N ""
    
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add "$SSH_KEY_PATH" 2> /dev/null

    printf "\n${GREEN}-------------------------------------------------------${NC}\n"
    printf "${YELLOW}ACTION REQUIRED: Copy the key below to your GitHub:${NC}\n"
    printf "Settings -> SSH and GPG keys -> New SSH key\n"
    printf "${GREEN}-------------------------------------------------------${NC}\n\n"
    cat "${SSH_KEY_PATH}.pub"
    printf "\n${GREEN}-------------------------------------------------------${NC}\n"

    printf "${YELLOW}Once you have added the key to GitHub, press [ENTER] to continue...${NC}"
    read IGNORE < /dev/tty
else
    printf "${GREEN}✔ SSH key already exists.${NC}\n"
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add "$SSH_KEY_PATH" 2> /dev/null
fi

# --- 6. Clone Repository ---
FULL_PATH=$(eval echo "$CLONE_DIR")
mkdir -p "$FULL_PATH"
cd "$FULL_PATH"

if [ -d "ftools" ]; then
    printf "${YELLOW}Folder 'ftools' already exists in %s. Skipping clone.${NC}\n" "$FULL_PATH"
else
    printf "${YELLOW}Cloning ftools into %s...${NC}\n" "$FULL_PATH"
    git clone git@github.com:ferranDelgado/ftools.git
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}✔ Successfully cloned ftools!${NC}\n"
    else
        printf "${RED}✘ Failed to clone. Verify your SSH key is on GitHub.${NC}\n"
    fi
fi

# --- 7. Final Shell Switch ---
if [[ "$SHELL" != *"zsh"* ]]; then
    printf "${YELLOW}Switching default shell to Zsh... (Password might be required)${NC}\n"
    sudo chsh -s "$(which zsh)" "$USER"
fi

printf "\n${GREEN}All done! Please log out and back in for Zsh to be your default.${NC}\n"
printf "\n${GREEN}Next steps after reopening terminal.${NC}\n"
printf "\t${YELLOW}1. Setup ohMyZsh running $FULL_PATH/ftools/setUpOhMyZsh.sh${NC}\n"
printf "\t${YELLOW}2. Install nvm $FULL_PATH/ftools/installNvm.sh${NC}\n"
printf "\t${YELLOW}3. Install nvm $FULL_PATH/ftools/installNvm.sh${NC}\n"
printf "\t${YELLOW}4. Install java 17 and gradle $FULL_PATH/ftools/installJvm.sh${NC}\n"
printf "\t${YELLOW}5. Install go $FULL_PATH/ftools/installGo.sh${NC}\n"
printf "\t${YELLOW}6. Install Docker $FULL_PATH/ftools/installDocker.sh${NC}\n"
