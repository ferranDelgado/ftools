# fTools 🔧

A small collection of scripts I use to bootstrap my development workstation on Debian/Ubuntu-based systems. These scripts automate installing common packages, developer tools, shell configuration, and language runtimes.

> Note: Some scripts are written for Ubuntu/Debian. Always review scripts before running them and run them with appropriate privileges (many require sudo).

---

## Table of contents

- Quickstart
- Scripts and Usage
- Troubleshooting
- Contributing
- License

---

## Quickstart ✅

Option A — Run the essentials installer directly (recommended for a fresh VM):

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ferranDelgado/ftools/main/install_essentials.sh)
```

Option B — Clone the repository and run scripts individually:

```bash
git clone https://github.com/ferranDelgado/ftools.git
cd ftools
# Run a specific installer, e.g.:
./install_essentials.sh
```

After running installers that modify your shell configuration, restart your terminal or source the appropriate file, for example:

```bash
source ~/.zshrc   # or source ~/.profile
```

---

## Scripts and Usage 📜

Below is a quick reference for the most important scripts in this repo and how to use them.

- `install_essentials.sh` — Bootstraps a new machine:
  - Installs core apps: curl, vim, git, htop, unzip, zsh, terminator, etc.
  - Configures Git user.name/user.email (prompts if missing), generates an SSH key, and clones the `ftools` repo into a chosen workspace directory.
  - Behavior: now runs with `set -euo pipefail` so it fails fast on errors. Run it as shown in Quickstart.

- `installNvm.sh` — Installs NVM (Node Version Manager):
  - Installs `nvm` (version pinned in the script) and runs `nvm install --lts`.
  - Sources `~/.zshrc` if present, otherwise sources `$HOME/.nvm/nvm.sh`. If neither can be sourced it prints an error and exits.
  - Usage: `./installNvm.sh`

- `installDocker.sh` — Installs Docker (Ubuntu):
  - Adds Docker repository, installs `docker-ce`, adds current user to the `docker` group, and enables the Docker service.
  - After running, log out/in or run `newgrp docker` so your user can run docker without `sudo`.
  - Usage: `./installDocker.sh`

- `installGo.sh` — Installs Go (golang):
  - Detects OS/arch, downloads the official tarball from go.dev and installs to `/usr/local`.
  - Updates PATH and GOPATH in `~/.profile`, `~/.bashrc`, and `~/.zshrc` if they don't already contain the entries.
  - Install a specific version via: `GO_VERSION=go1.25.5 ./installGo.sh` (omit `GO_VERSION` to install the latest stable).

- `installJvm.sh` — Installs SDKMAN, Java 17 (Temurin) and Gradle via SDKMAN.
  - Usage: `./installJvm.sh`

- `setUpOhMyZsh.sh` — Configures Zsh and dotfiles
  - Backs up existing `~/.zshrc`, `~/.vimrc`, and `~/.gitconfig`, then symlinks repository dotfiles to your home directory.
  - After running, `source ~/.zshrc` or restart the shell.

- `installTools.sh` — Installs smaller developer tools and helpers (terminator, vim, unzip, tmux, etc.) and sets up tmux config and SDKMAN if needed.

- `installSublime.sh`, `installLibreOffice.sh` — Install Sublime Text and LibreOffice respectively.

- Utility scripts:
  - `basic.sh` — logging helpers (`info`, `warn`, `error`) used by other scripts.
  - `helper.sh` — miscellaneous helper functions (e.g., color display).
  - `scripts/tfswitch.sh` — terraform workspace helper (if present).

---

## Troubleshooting & Notes ⚠️

- nvm: After `installNvm.sh`, you may need to `source ~/.zshrc` or open a new terminal for `nvm` to be available.
- docker: If you still need `sudo` for `docker` after running the installer, log out and log back in to refresh group membership.
- go: If `go` is not found immediately after `installGo.sh`, run `source ~/.profile` or open a new terminal.
- Scripts may prompt for input (e.g., Git email/name or pressing Enter after key generation). Run them in a local interactive shell when possible.

---
