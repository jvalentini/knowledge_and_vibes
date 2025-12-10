#!/usr/bin/env bash
#
# install-kv.sh - Install the knowledge_and_vibes CLI
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Default install location
INSTALL_DIR="${HOME}/.local/bin"

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: install-kv.sh [--dir /path/to/bin]"
            echo ""
            echo "Installs the 'kv' CLI to ~/.local/bin (default) or specified directory."
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Create install directory if needed
if [ ! -d "$INSTALL_DIR" ]; then
    printf "${YELLOW}Creating $INSTALL_DIR...${NC}\n"
    mkdir -p "$INSTALL_DIR"
fi

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy kv to install location
printf "Installing kv to ${INSTALL_DIR}...\n"
cp "$SCRIPT_DIR/kv" "$INSTALL_DIR/kv"
chmod +x "$INSTALL_DIR/kv"

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    printf "${YELLOW}Note: $INSTALL_DIR is not in your PATH.${NC}\n"
    printf "Add this to your shell profile:\n"
    printf "  ${GREEN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}\n"
    echo ""
fi

printf "${GREEN}✓ Installed! Run 'kv' to get started.${NC}\n"
