#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

PKG_NAME="local-agents"

print_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  (no arguments)  Build and install the local-agents package"
    echo "  uninstall       Remove the local-agents package from the system"
    echo "  help            Show this help message"
}

# If no arguments are passed, build and install
if [ $# -eq 0 ]; then
    echo "=== Starting Build and Installation of ${PKG_NAME} ==="
    
    # PKGEXT='.pkg.tar' bypasses zstd compression to save massive amounts of time on 20GB+ SIF files
    # -i installs the package natively via pacman once compiled
    PKGEXT='.pkg.tar' makepkg -i

    echo "=== Installation complete ==="

# Handle explicit uninstall request
elif [ "$1" == "uninstall" ]; then
    echo "=== Removing ${PKG_NAME} from the system ==="
    
    # Check if the package is actually installed before trying to remove it
    if pacman -Qq "$PKG_NAME" &>/dev/null; then
        sudo pacman -R "$PKG_NAME"
        echo "=== Uninstallation complete ==="
    else
        echo "Package '${PKG_NAME}' is not currently installed."
    fi

# Handle explicit help request or any invalid arguments
elif [ "$1" == "help" ] || [ $# -gt 0 ]; then
    print_help
    exit 0
fi
