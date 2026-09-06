#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Prefer the repo's basic helper if available for consistent output, else fallback
if [ -r "$SCRIPT_DIR/basic.sh" ]; then
    # shellcheck source=/dev/null
    source "$SCRIPT_DIR/basic.sh"
else
    info() { printf "\033[0;34m==>\033[0m %s\n" "$*"; }
    error() { printf "\033[0;31mERROR:\033[0m %s\n" "$*" >&2; }
fi

info "Starting Android SDK installation"

# 1. Install prerequisites
sudo apt update
sudo apt install -y android-sdk-platform-tools-common wget unzip libc6-dev-i386 lib32z1

# 2. Setup SDK directory structure safely
SDK_DIR="$HOME/Android/Sdk"
CMDLINE_DIR="$SDK_DIR/cmdline-tools"

mkdir -p "$CMDLINE_DIR"
TMP_DIR="$(mktemp -d)"

# Ensure temporary files are cleaned up on exit
trap 'rm -rf "$TMP_DIR"' EXIT

# 3. Download and extract to temporary folder
info "Downloading Android Command Line Tools..."
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O "$TMP_DIR/cmdline-tools.zip"
unzip -q "$TMP_DIR/cmdline-tools.zip" -d "$TMP_DIR"

# 4. Move extracted contents to target 'latest' folder
rm -rf "$CMDLINE_DIR/latest"
mv "$TMP_DIR/cmdline-tools" "$CMDLINE_DIR/latest"

# 5. Append environment variables if not already present
ZSH_CONFIG="$HOME/.zshrc_private"
touch "$ZSH_CONFIG"

if ! grep -q "ANDROID_HOME" "$ZSH_CONFIG"; then
    info "Configuring environment variables in $ZSH_CONFIG"
    {
        echo ''
        echo '# Android SDK Configuration'
        echo 'export ANDROID_HOME=$HOME/Android/Sdk'
        echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/34.0.0'
    } >> "$ZSH_CONFIG"
fi

SDKMANAGER="$CMDLINE_DIR/latest/bin/sdkmanager"

# 6. Install Android Platform & Build Tools
info "Installing platform-tools, platforms;android-34, build-tools;34.0.0..."
"$SDKMANAGER" "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 7. Accept SDK licenses automatically
info "Accepting SDK licenses..."
yes | "$SDKMANAGER" --licenses > /dev/null

info "Android SDK setup complete."
cd "$SCRIPT_DIR"
exit 0