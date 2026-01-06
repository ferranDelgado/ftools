#!/usr/bin/env bash
set -euo pipefail

# Install Go (golang) to /usr/local and add to user PATH
# Usage:
#   GO_VERSION=go1.21.8 ./installGo.sh   # install specific version
#   ./installGo.sh                        # install latest

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Prefer the repo's basic helper if available for consistent output, else fallback
if [ -r "$SCRIPT_DIR/basic.sh" ]; then
    # shellcheck source=/dev/null
    source "$SCRIPT_DIR/basic.sh"
else
    info() { printf "\033[0;34m==>\033[0m %s\n" "$*"; }
    error() { printf "\033[0;31mERROR:\033[0m %s\n" "$*" >&2; }
fi

info "Starting Go installation"

# Determine OS and ARCH
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH_RAW="$(uname -m)"
case "$ARCH_RAW" in
    x86_64|amd64) ARCH=amd64 ;;
    aarch64|arm64) ARCH=arm64 ;;
    *) error "Unsupported architecture: $ARCH_RAW"; exit 1 ;;
esac

# Resolve version
if [ -n "${GO_VERSION:-}" ]; then
    VER="$GO_VERSION"
else
    info "Fetching latest Go version..."
    # Take only the first line (the endpoint returns version + timestamp on separate lines)
    VER="$(curl -fsS https://go.dev/VERSION?m=text | head -n1 | tr -d '\r')" || { error "Failed to fetch latest version"; exit 1; }
    # Basic validation: version should start with 'go' (e.g. go1.25.5)
    if [[ ! "$VER" =~ ^go[0-9] ]]; then
        error "Unexpected version string from server: '$VER'"
        exit 1
    fi
fi

# Expected tarball and URL
TARBALL="${VER}.${OS}-${ARCH}.tar.gz"
URL="https://go.dev/dl/${TARBALL}"

info "Will install: $VER ($OS/$ARCH)"
info "Downloading $URL"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
DEST="$TMPDIR/$TARBALL"

curl -fsSL "$URL" -o "$DEST" || { error "Download failed: $URL"; exit 1; }

# (Optional) checksum verification could be added here by fetching the checksum file from go.dev

info "Removing any existing /usr/local/go (requires sudo)"
sudo rm -rf /usr/local/go

info "Extracting $TARBALL to /usr/local"
sudo tar -C /usr/local -xzf "$DEST"

# Add PATH and GOPATH to shell rc files if not present
PROFILE_LINE='export PATH="/usr/local/go/bin:$PATH"'
GOPATH_LINE='export GOPATH="$HOME/go"'
GOBIN_LINE='export PATH="$GOPATH/bin:$PATH"'

update_rc() {
    local rcfile="$1"
    if [ -f "$rcfile" ]; then
        if ! grep -Fxq "$PROFILE_LINE" "$rcfile" 2>/dev/null; then
            printf "\n# Go configuration added by installGo.sh\n%s\n" "$PROFILE_LINE" >> "$rcfile"
            info "Added PATH to $rcfile"
        fi
        if ! grep -Fxq "$GOPATH_LINE" "$rcfile" 2>/dev/null; then
            printf "%s\n" "$GOPATH_LINE" >> "$rcfile"
            info "Added GOPATH to $rcfile"
        fi
        if ! grep -Fxq "$GOBIN_LINE" "$rcfile" 2>/dev/null; then
            printf "%s\n" "$GOBIN_LINE" >> "$rcfile"
            info "Added GOBIN to $rcfile"
        fi
    fi
}

# Update common rc files
update_rc "$HOME/.profile"
update_rc "$HOME/.bashrc"
update_rc "$HOME/.zshrc"

info "Installation complete. Verifying..."

# Verify go is available (note: the current shell might not have updated PATH yet)
if command -v go >/dev/null 2>&1; then
    go version
    info "Go installed successfully. You may need to restart your shell to pick up changes."
else
    info "go command not found in this shell. Try: 'source ~/.profile' or start a new shell, then run 'go version'"
fi

exit 0
