#!/bin/bash
# -----------------------------------------------------------------------------
# LazyVim School Installer (No Sudo Required)
# -----------------------------------------------------------------------------
# Goals:
# 1. Install Neovim (AppImage) to ~/.local/bin
# 2. Backup existing config to ~/.config/nvim.backup.<date>
# 3. Symlink this repo's config to ~/.config/nvim
# 4. Use existing tools (fzf, bat, fd) in ~/.local/bin
# -----------------------------------------------------------------------------

set -e # Exit on error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎓 Initializing LazyVim Setup (School Edition)...${NC}"

# 1. Setup ~/.local/bin
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
# Add to PATH locally for this script
export PATH="$INSTALL_DIR:$PATH"

# 2. Check/Install Neovim Binary
if command -v nvim &> /dev/null; then
    echo -e "${GREEN}✅ Neovim is already installed: $(nvim --version | head -n 1)${NC}"
else
    echo -e "${YELLOW}⬇️  Neovim not found. Downloading latest AppImage...${NC}"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage "$INSTALL_DIR/nvim"
    echo -e "${GREEN}✅ Neovim installed to $INSTALL_DIR/nvim${NC}"
fi

# 3. Check for existing utils
echo -e "${BLUE}🔍 Checking for utilities in $INSTALL_DIR...${NC}"
for tool in fzf bat fd rg; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}  - Found $tool${NC}"
    else
        echo -e "${YELLOW}  - Missing $tool (LazyVim might complain, but will work)${NC}"
    fi # Correction: Changed 'end' to 'fi'
done

# 4. Deploy Configuration (The Safe Way)
CONFIG_DIR="$HOME/.config/nvim"
REPO_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}📦 Deploying Configuration...${NC}"

# Verify we are in the right place
if [ ! -f "$REPO_CONFIG_DIR/init.lua" ]; then
    echo -e "${RED}❌ Error: Could not find init.lua in $REPO_CONFIG_DIR${NC}"
    echo "Please run this script from inside the lazyvim_config folder."
    exit 1
fi

# Backup existing config
if [ -d "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
    BACKUP_NAME="$CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}⚠️  Existing config found! Moving to $BACKUP_NAME${NC}"
    mv "$CONFIG_DIR" "$BACKUP_NAME"
fi

# Symlink new config
ln -s "$REPO_CONFIG_DIR" "$CONFIG_DIR"
echo -e "${GREEN}✅ Configuration linked: $CONFIG_DIR -> $REPO_CONFIG_DIR${NC}"

# 5. Final Instructions
echo -e "\n${GREEN}🎉 Setup Complete!${NC}"
echo -e "1. Ensure $INSTALL_DIR is in your PATH."
echo -e "   Run: ${YELLOW}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC} (Add to ~/.bashrc or ~/.zshrc)"
echo -e "2. Run ${BLUE}nvim${NC}. It will now start installing plugins (~3-5 mins)."
echo -e "   Note: Since you have limited space (2GB), keep an eye on usage."
echo -e "   Run: ${YELLOW}du -sh ~/.local/share/nvim${NC} to check plugin size."
