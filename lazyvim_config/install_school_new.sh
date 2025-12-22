#!/bin/bash
set -e

# --- CONFIG ---
INSTALL_DIR="$HOME/.local/bin"
NVIM_DIR="$INSTALL_DIR/nvim_app"
NVIM_BIN="$INSTALL_DIR/nvim"

# --- 1. PREP ---
mkdir -p "$INSTALL_DIR"
export PATH="$INSTALL_DIR:$PATH"

echo "🔍 Checking for Neovim..."
if [ -f "$NVIM_BIN" ]; then
  echo "✅ Neovim already installed."
else
  echo "⬇️  Downloading Neovim AppImage..."
  cd "$INSTALL_DIR"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage

  # EXTRACT (For ManPager Support)
  echo "📦 Extracting AppImage..."
  ./nvim.appimage --appimage-extract >/dev/null
  mv squashfs-root "$NVIM_DIR"
  rm nvim.appimage

  # LINK
  ln -s "$NVIM_DIR/usr/bin/nvim" "$NVIM_BIN"
  echo "✅ Installed to $NVIM_BIN"
fi

# --- 2. CONFIG MANPAGER ---
echo "export MANPAGER='$NVIM_DIR/usr/bin/nvim +Man!'" >>"$HOME/.zshrc"
echo "export PATH='$INSTALL_DIR:\$PATH'" >>"$HOME/.zshrc"
echo "✅ Added MANPAGER and PATH to ~/.zshrc"

# --- 3. DEPLOY CONFIG ---
CONFIG_DEST="$HOME/.config/nvim"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$CONFIG_DEST" ] && [ ! -L "$CONFIG_DEST" ]; then
  mv "$CONFIG_DEST" "$CONFIG_DEST.backup.$(date +%s)"
  echo "📦 Backed up existing nvim config."
fi

# Link if not already linked
if [ ! -L "$CONFIG_DEST" ]; then
  ln -s "$REPO_DIR" "$CONFIG_DEST"
  echo "🔗 Symlinked Config: $CONFIG_DEST -> $REPO_DIR"
fi

echo "🎉 DONE! Restart your terminal."
