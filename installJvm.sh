#!/bin/bash
source basic.sh
info "Installing SDKMAN and Java 17..."

curl -s "https://get.sdkman.io" | bash

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if command -v sdk &> /dev/null; then
    if ! sdk current java | grep -q "17"; then
        warn "Installing Java 17 (Temurin)..."
        sdk install java 17.0.10-tem > /dev/null
    else
        info "Java 17 is already installed via SDKMAN."
    fi
fi

warn "Installing Gradle..."
sdk install gradle > /dev/null
