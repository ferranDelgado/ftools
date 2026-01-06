#!/bin/bash
source basic.sh
PWD="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# backup existing zsh config files (keep a list of created backups)
BACKUPS=()
timestamp() { date +%Y%m%dT%H%M%S; }

backup_file() {
    src="$1"
    dest_base="$2"
    if [ -e "$src" ]; then
        if [ ! -e "$dest_base" ]; then
            info "Backing up '$src' -> '$dest_base'"
            mv "$src" "$dest_base"
            BACKUPS+=("$dest_base")
        else
            ts=$(timestamp)
            dest="${dest_base}.${ts}"
            info "Backup already exists; moving '$src' -> '$dest'"
            mv "$src" "$dest"
            BACKUPS+=("$dest")
        fi
    fi
}

backup_file "$HOME/.zshrc" "$HOME/.zshrc.backup"
backup_file "$HOME/.vimrc" "$HOME/.vimrc.backup"
backup_file "$HOME/.gitconfig" "$HOME/.gitconfig.backup"

# create symlinks for dotfiles from repo to home
ln -nfs "$PWD/.zshrc" "$HOME/.zshrc"

# vim
ln -nfs "$PWD/.vimrc" "$HOME/.vimrc"

# zsh customization
ln -nfs "$PWD/zsh_customizations" "$HOME/zsh_customizations"

# gitconfig
ln -nfs "$PWD/.gitconfig" "$HOME/.gitconfig"

# Summary of backups
if [ ${#BACKUPS[@]} -gt 0 ]; then
    info "Created backups:"
    for b in "${BACKUPS[@]}"; do
        info "  - $b"
    done
else
    info "No existing zsh config files were backed up."
fi

info "Dotfiles setup complete."
warning "Please run 'source ~/.zshrc' or restart your terminal to apply changes."