#!/bin/bash

# ============================================================================
# 🚀 ULTIMATE NEOVIM INSTALLER (Portable)
# ============================================================================
# This script installs your exact custom Neovim setup from this folder.
# It is designed to run without 'sudo' (User Space Only).
# Perfect for school machines (42 School) or new setups.
# ============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}"
cat << "BANNER"
╔══════════════════════════════════════════════════════════════╗
║        🚀 ULTIMATE NEOVIM DEPLOYMENT PROTOCOL 🚀             ║
║                                                              ║
║  • Source:      Local Folder (Your Custom Stack)             ║
║  • Destination: ~/.config/nvim                               ║
║  • Permissions: User Only (No Sudo Needed)                   ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

# ============================================================================
# Step 1: Check Neovim Version
# ============================================================================
echo -e "${YELLOW}🔍 Checking Neovim...${NC}"

NEED_INSTALL=0
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}✗ Neovim not found.${NC}"
    NEED_INSTALL=1
else
    # Check version (Need >= 0.9.0)
    VERSION=$(nvim --version | head -n 1 | grep -oP 'v\K[0-9]+\.[0-9]+')
    MAJOR=$(echo $VERSION | cut -d. -f1)
    MINOR=$(echo $VERSION | cut -d. -f2)
    
    if [ "$MAJOR" -eq 0 ] && [ "$MINOR" -lt 9 ]; then
        echo -e "${RED}✗ Old Neovim found ($VERSION). Need >= 0.9.0${NC}"
        NEED_INSTALL=1
    else
        echo -e "${GREEN}✓ Neovim $VERSION detected (Good).${NC}"
    fi
fi

if [ "$NEED_INSTALL" -eq 1 ]; then
    echo -e "${BLUE}⬇️  Installing Neovim (AppImage) to ~/.local/bin...${NC}"
    mkdir -p ~/.local/bin
    # Download latest stable
    curl -L -o ~/.local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod +x ~/.local/bin/nvim
    
    # Add to path if needed (temporary for this session, instructs user for permanent)
    export PATH="$HOME/.local/bin:$PATH"
    echo -e "${GREEN}✓ Neovim installed.${NC}"
    echo -e "${YELLOW}⚠️  IMPORTANT: Add this to your ~/.zshrc or ~/.bashrc:${NC}"
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# ============================================================================
# Step 2: Deploy Configuration
# ============================================================================
echo -e "\n${YELLOW}📦 Deploying Configuration...${NC}"

# Verify source exists
if [ ! -d "$SCRIPT_DIR/nvim" ]; then
    echo -e "${RED}✗ Error: 'nvim' folder not found in script directory ($SCRIPT_DIR).${NC}"
    echo "Make sure you copied the full folder structure."
    exit 1
fi

# Backup existing
if [ -d "$HOME/.config/nvim" ]; then
    echo -e "${BLUE}ℹ️  Backing up existing config to $BACKUP_DIR...${NC}"
    mv "$HOME/.config/nvim" "$BACKUP_DIR"
fi

# Link or Copy (Copying is safer for portability if source moves)
echo -e "${BLUE}ℹ️  Installing new config...${NC}"
mkdir -p "$HOME/.config"
cp -r "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

echo -e "${GREEN}✓ Config installed successfully.${NC}"

# ============================================================================
# Step 3: Deploy Practice Arena
# ============================================================================
echo -e "\n${YELLOW}⚔️  Deploying Practice Arena...${NC}"

if [ -d "$SCRIPT_DIR/lazyvim_practice_arena" ]; then
    if [ -d "$HOME/lazyvim_practice_arena" ]; then
         echo -e "${BLUE}ℹ️  Practice Arena already exists. Skipping overwrite (manual check advised).${NC}"
    else
         cp -r "$SCRIPT_DIR/lazyvim_practice_arena" "$HOME/lazyvim_practice_arena"
         echo -e "${GREEN}✓ Practice Arena deployed to ~/lazyvim_practice_arena${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Practice Arena source not found. Skipping.${NC}"
fi

# ============================================================================
# Step 4: System Dependencies (Check Only)
# ============================================================================
echo -e "\n${YELLOW}🔍 Checking Dependencies (Optional but Recommended)...${NC}"

check_cmd() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓ $1 found.${NC}"
    else
        echo -e "${RED}✗ $1 NOT found.${NC} (Recommended)"
    fi
}

check_cmd "rg"     # ripgrep
check_cmd "fd"     # fd-find
check_cmd "gcc"    # compiler
check_cmd "git"    # git

echo -e "\n${BLUE}ℹ️  If 'rg' or 'fd' are missing, Telescope search might be slow.${NC}"
echo -e "   On School Linux, you might verify if they are installed or use binaries."

# ============================================================================
# Step 5: Finalize
# ============================================================================
echo -e "\n${GREEN}✅ INSTALLATION COMPLETE!${NC}"
echo -e "1. Restart your terminal."
echo -e "2. Run 'nvim'."
echo -e "3. Wait for LazyVim to install plugins (it will happen automatically)."
echo -e "4. Press '${YELLOW}<Space> ch${NC}' to check for any health issues."
echo -e "\n${BLUE}Enjoy your Ultimate Neovim!${NC}"
