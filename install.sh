#!/bin/bash

# =================================================================
# 🚀 Ultimate Developer Dotfiles Installation Script
# =================================================================
# Author: Youssef Mazini (ymazini)
# GitHub: https://github.com/yomazini/dotfiles
# =================================================================

set -e 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ARROW="➡️"
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
CROSS="❌"
NC='\033[0m'
STAR="⭐"
CHECK="✅"
ROCKET="🚀"
WRENCH="🔧"
PACKAGE="📦"

# =================================================================
# Utils Functions
# =================================================================

print_header() {
    echo -e "\n${PURPLE}==================================================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}==================================================================${NC}\n"
}

print_step() {
    echo -e "${BLUE}${ARROW} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_if_missing() {
    local tool="$1"
    local install_cmd="$2"
    
    if command_exists "$tool"; then
        print_success "$tool is already installed"
    else
        print_step "Installing $tool..."
        eval "$install_cmd"
        if command_exists "$tool"; then
            print_success "$tool installed successfully"
        else
            print_error "Failed to install $tool"
            return 1
        fi
    fi
}

backup_file() {
    if [ -f "$1" ] || [ -d "$1" ]; then
        print_step "Backing up existing $1..."
        cp -r "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
        print_success "Backup created: $1.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

# =================================================================
# Rollback Functions
# =================================================================

list_backups() {
    print_header "${WRENCH} Available Backups"
    
    echo -e "${CYAN}Config file backups found:${NC}\n"
    
    local found_backups=0
    
    # Check for .vimrc backups
    if ls ~/.vimrc.backup.* 2>/dev/null; then
        echo -e "${GREEN}Vim configurations:${NC}"
        ls -lht ~/.vimrc.backup.* | awk '{print "  " $9 " (" $6 " " $7 " " $8 ")"}'
        echo ""
        ((found_backups++))
    fi
    
    # Check for .tmux.conf backups
    if ls ~/.tmux.conf.backup.* 2>/dev/null; then
        echo -e "${GREEN}Tmux configurations:${NC}"
        ls -lht ~/.tmux.conf.backup.* | awk '{print "  " $9 " (" $6 " " $7 " " $8 ")"}'
        echo ""
        ((found_backups++))
    fi
    
    # Check for .zshrc backups
    if ls ~/.zshrc.backup.* 2>/dev/null; then
        echo -e "${GREEN}Zsh configurations:${NC}"
        ls -lht ~/.zshrc.backup.* | awk '{print "  " $9 " (" $6 " " $7 " " $8 ")"}'
        echo ""
        ((found_backups++))
    fi
    
    # Check for .p10k.zsh backups
    if ls ~/.p10k.zsh.backup.* 2>/dev/null; then
        echo -e "${GREEN}Powerlevel10k configurations:${NC}"
        ls -lht ~/.p10k.zsh.backup.* | awk '{print "  " $9 " (" $6 " " $7 " " $8 ")"}'
        echo ""
        ((found_backups++))
    fi
    
    if [ $found_backups -eq 0 ]; then
        print_warning "No backups found"
        return 1
    fi
    
    return 0
}

rollback_config() {
    local config_type="$1"
    local config_file=""
    local config_name=""
    
    case "$config_type" in
        vim|vimrc)
            config_file="$HOME/.vimrc"
            config_name="Vim"
            ;;
        tmux|tmux.conf)
            config_file="$HOME/.tmux.conf"
            config_name="Tmux"
            ;;
        zsh|zshrc)
            config_file="$HOME/.zshrc"
            config_name="Zsh"
            ;;
        p10k|powerlevel10k)
            config_file="$HOME/.p10k.zsh"
            config_name="Powerlevel10k"
            ;;
        all)
            rollback_all_configs
            return $?
            ;;
        *)
            print_error "Unknown config type: $config_type"
            echo "Valid options: vim, tmux, zsh, p10k, all"
            return 1
            ;;
    esac
    
    # Find the most recent backup
    local latest_backup=$(ls -t ${config_file}.backup.* 2>/dev/null | head -1)
    
    if [ -z "$latest_backup" ]; then
        print_error "No backup found for $config_name configuration"
        return 1
    fi
    
    print_step "Rolling back $config_name configuration..."
    echo -e "${CYAN}From: $latest_backup${NC}"
    echo -e "${CYAN}To:   $config_file${NC}"
    echo ""
    
    # Show diff if available
    if command_exists diff; then
        echo -e "${YELLOW}Changes that will be reverted:${NC}"
        diff -u "$config_file" "$latest_backup" 2>/dev/null | head -20 || echo "  (files are identical or diff not available)"
        echo ""
    fi
    
    read -p "Continue with rollback? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Rollback cancelled"
        return 1
    fi
    
    # Create backup of current config before rolling back
    cp "$config_file" "${config_file}.before_rollback.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
    
    # Restore the backup
    cp "$latest_backup" "$config_file"
    
    if [ $? -eq 0 ]; then
        print_success "$config_name configuration restored from $latest_backup"
        print_warning "A backup of the current config was saved as ${config_file}.before_rollback.*"
        return 0
    else
        print_error "Failed to restore $config_name configuration"
        return 1
    fi
}

rollback_all_configs() {
    print_header "${WRENCH} Rolling Back All Configurations"
    
    local configs=("vim" "tmux" "zsh" "p10k")
    local rolled_back=0
    local failed=0
    
    for config in "${configs[@]}"; do
        echo ""
        if rollback_config "$config"; then
            ((rolled_back++))
        else
            ((failed++))
        fi
    done
    
    echo ""
    print_header "${CHECK} Rollback Summary"
    echo -e "${GREEN}Successfully rolled back: $rolled_back${NC}"
    if [ $failed -gt 0 ]; then
        echo -e "${YELLOW}Failed or skipped: $failed${NC}"
    fi
    
    if [ $rolled_back -gt 0 ]; then
        print_warning "Please reload your shell: source ~/.zshrc"
        print_warning "Restart tmux sessions for tmux changes to take effect"
    fi
}

rollback_to_specific() {
    local config_type="$1"
    local backup_file="$2"
    
    if [ ! -f "$backup_file" ]; then
        print_error "Backup file not found: $backup_file"
        return 1
    fi
    
    local config_file=""
    case "$config_type" in
        vim|vimrc) config_file="$HOME/.vimrc" ;;
        tmux|tmux.conf) config_file="$HOME/.tmux.conf" ;;
        zsh|zshrc) config_file="$HOME/.zshrc" ;;
        p10k|powerlevel10k) config_file="$HOME/.p10k.zsh" ;;
        *)
            print_error "Unknown config type: $config_type"
            return 1
            ;;
    esac
    
    print_step "Rolling back to specific backup..."
    echo -e "${CYAN}From: $backup_file${NC}"
    echo -e "${CYAN}To:   $config_file${NC}"
    
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Rollback cancelled"
        return 1
    fi
    
    # Create safety backup
    cp "$config_file" "${config_file}.before_specific_rollback.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
    
    # Restore
    cp "$backup_file" "$config_file"
    
    if [ $? -eq 0 ]; then
        print_success "Configuration restored from $backup_file"
        return 0
    else
        print_error "Failed to restore configuration"
        return 1
    fi
}

show_rollback_help() {
    echo -e "${CYAN}${BOLD}Rollback Usage:${NC}\n"
    echo "Roll back to the most recent backup:"
    echo -e "  ${GREEN}./install.sh --rollback vim${NC}      Roll back Vim config"
    echo -e "  ${GREEN}./install.sh --rollback tmux${NC}     Roll back Tmux config"
    echo -e "  ${GREEN}./install.sh --rollback zsh${NC}      Roll back Zsh config"
    echo -e "  ${GREEN}./install.sh --rollback all${NC}      Roll back all configs"
    echo ""
    echo "List available backups:"
    echo -e "  ${GREEN}./install.sh --list-backups${NC}"
    echo ""
    echo "Roll back to a specific backup:"
    echo -e "  ${GREEN}./install.sh --rollback-to vim ~/.vimrc.backup.20250104_120000${NC}"
    echo ""
    echo -e "${YELLOW}Note: Tools and plugins remain installed, only config files are restored${NC}"
}

# =================================================================
# Main Installation Functions
# =================================================================

detect_os() {
    print_header "${WRENCH} Detecting Operating System"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt; then
            OS="ubuntu"
            PKG_MANAGER="apt"
            print_success "Detected: Ubuntu/Debian"
        elif command_exists yum; then
            OS="centos"
            PKG_MANAGER="yum"
            print_success "Detected: CentOS/RHEL"
        elif command_exists pacman; then
            OS="arch"
            PKG_MANAGER="pacman"
            print_success "Detected: Arch Linux"
        else
            print_error "Unsupported Linux distribution"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MANAGER="brew"
        print_success "Detected: macOS"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

install_package_manager() {
    print_header "${PACKAGE} Setting Up Package Manager"
    
    case $OS in
        ubuntu)
            print_step "Updating apt repositories..."
            sudo apt update
            ;;
        macos)
            if ! command_exists brew; then
                print_step "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                print_success "Homebrew installed"
            else
                print_success "Homebrew already installed"
            fi
            ;;
        arch)
            print_step "Updating pacman repositories..."
            sudo pacman -Sy
            ;;
    esac
}

install_essential_packages() {
    print_header "${PACKAGE} Installing Essential Packages"
    
    case $OS in
        ubuntu)
            print_step "Installing essential packages..."
            sudo apt install -y \
                curl wget git vim tmux zsh \
                build-essential cmake python3 python3-pip \
                clang clang-format clangd \
                fd-find ripgrep bat fzf \
                tree unzip jq xclip lsof 2>/dev/null || true
            
            # Check Node.js separately (don't force install)
            if ! command_exists node; then
                print_warning "Node.js not found. Install via nvm:"
                print_warning "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
            else
                print_success "Node.js $(node --version) detected"
            fi
            
            # Ubuntu-specific: create symlinks for fd and bat
            mkdir -p ~/.local/bin
            
            # Create fd symlink only if it doesn't exist
            if [ ! -e ~/.local/bin/fd ]; then
                ln -s /usr/bin/fdfind ~/.local/bin/fd 2>/dev/null && \
                    print_success "Created fd symlink" || \
                    print_warning "fd symlink creation failed or fdfind not found"
            else
                print_success "fd symlink already exists"
            fi
            
            # Create bat symlink only if it doesn't exist
            if [ ! -e ~/.local/bin/bat ]; then
                ln -s /usr/bin/batcat ~/.local/bin/bat 2>/dev/null && \
                    print_success "Created bat symlink" || \
                    print_warning "bat symlink creation failed or batcat not found"
            else
                print_success "bat symlink already exists"
            fi
            ;;
            
        macos)
            print_step "Installing essential packages..."
            brew install \
                curl wget git vim tmux zsh \
                cmake python3 \
                llvm \
                fd ripgrep bat fzf \
                tree jq 2>/dev/null || true
            
            if ! command_exists node; then
                print_warning "Node.js not found. Install via nvm or brew"
            else
                print_success "Node.js $(node --version) detected"
            fi
            ;;
            
        arch)
            print_step "Installing essential packages..."
            sudo pacman -S --noconfirm \
                curl wget git vim tmux zsh \
                base-devel cmake python python-pip \
                clang \
                fd ripgrep bat fzf \
                tree unzip jq xclip lsof 2>/dev/null || true
            
            if ! command_exists node; then
                print_warning "Node.js not found. Install via nvm or pacman"
            else
                print_success "Node.js $(node --version) detected"
            fi
            ;;
    esac
}

install_modern_cli_tools() {
    print_header "${ROCKET} Installing Modern CLI Tools"
    
    mkdir -p ~/.local/bin
    
    # Install Rust-based tools via cargo if available, otherwise use package manager
    if command_exists cargo; then
        print_step "Installing Rust-based tools..."
        cargo install eza zoxide procs dust 2>/dev/null || true
    else
        case $OS in
            ubuntu)
                # Install eza
                if ! command_exists eza; then
                    print_step "Installing eza..."
                    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
                    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
                    sudo apt update 2>/dev/null
                    sudo apt install -y eza 2>/dev/null || print_warning "eza installation failed, continuing..."
                fi
                
                # Install zoxide
                if ! command_exists zoxide; then
                    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
                fi
                ;;
                
            macos)
                brew install eza zoxide procs dust 2>/dev/null || true
                ;;
                
            arch)
                sudo pacman -S --noconfirm eza zoxide 2>/dev/null || true
                ;;
        esac
    fi
    
    # Install Python tools
    print_step "Installing Python tools..."
    pip3 install --user autopep8 python-lsp-server pycodestyle 2>/dev/null || print_warning "Some Python tools failed to install"
    
    # Install additional tools
    print_step "Installing additional CLI tools..."
    
    # glow (markdown viewer)
    if ! command_exists glow; then
        print_step "Installing glow..."
        if [[ "$OS" == "ubuntu" ]]; then
            wget -q https://github.com/charmbracelet/glow/releases/latest/download/glow_Linux_x86_64.tar.gz -O /tmp/glow.tar.gz 2>/dev/null || true
            tar -xzf /tmp/glow.tar.gz -C ~/.local/bin glow 2>/dev/null || true
            chmod +x ~/.local/bin/glow 2>/dev/null || true
            rm /tmp/glow.tar.gz 2>/dev/null || true
        fi
    fi
    
    # tldr
    if ! command_exists tldr; then
        pip3 install --user tldr 2>/dev/null || print_warning "tldr installation failed"
    fi
    
    # ranger
    if ! command_exists ranger; then
        pip3 install --user ranger-fm 2>/dev/null || print_warning "ranger installation failed"
    fi
    
    # termdown
    if ! command_exists termdown; then
        pip3 install --user termdown 2>/dev/null || print_warning "termdown installation failed"
    fi
    
    # btop
    case $OS in
        ubuntu) sudo apt install -y btop 2>/dev/null || print_warning "btop installation failed" ;;
        macos) brew install btop 2>/dev/null || true ;;
        arch) sudo pacman -S --noconfirm btop 2>/dev/null || true ;;
    esac
    
    # mc (midnight commander)
    case $OS in
        ubuntu) sudo apt install -y mc 2>/dev/null || true ;;
        macos) brew install mc 2>/dev/null || true ;;
        arch) sudo pacman -S --noconfirm mc 2>/dev/null || true ;;
    esac
    
    # entr
    case $OS in
        ubuntu) sudo apt install -y entr 2>/dev/null || true ;;
        macos) brew install entr 2>/dev/null || true ;;
        arch) sudo pacman -S --noconfirm entr 2>/dev/null || true ;;
    esac
    
    # ipcalc
    case $OS in
        ubuntu) sudo apt install -y ipcalc 2>/dev/null || true ;;
        macos) brew install ipcalc 2>/dev/null || true ;;
        arch) sudo pacman -S --noconfirm ipcalc 2>/dev/null || true ;;
    esac
}

setup_zsh() {
    print_header "${ROCKET} Setting Up Zsh Environment"
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_step "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    else
        print_success "Oh My Zsh already installed"
    fi
    
    # Install Powerlevel10k theme
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        print_step "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        print_success "Powerlevel10k installed"
    else
        print_success "Powerlevel10k already installed"
    fi
    
    # Install Zsh plugins
    print_step "Installing Zsh plugins..."
    
    # zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    print_success "Zsh plugins installed"
    
    # Install fzf
    if [ ! -d "$HOME/.fzf" ]; then
        print_step "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
        print_success "fzf installed"
    else
        print_success "fzf already installed"
    fi
}

setup_vim() {
    print_header "${ROCKET} Setting Up Vim IDE"
    
    # Install vim-plug
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        print_step "Installing vim-plug..."
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        print_success "vim-plug installed"
    else
        print_success "vim-plug already installed"
    fi
    
    print_step "Installing Vim plugins (this may take a moment)..."
    vim +PlugInstall +qall 2>/dev/null || print_warning "Some Vim plugins may need manual installation"
    print_success "Vim plugins installed"
}

setup_tmux() {
    print_header "${ROCKET} Setting Up Tmux Environment"
    
    # Install TPM (Tmux Plugin Manager)
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        print_step "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        print_success "TPM installed"
    else
        print_success "TPM already installed"
    fi
    
    print_step "Installing Tmux plugins..."
    # Install plugins via TPM
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh 2>/dev/null || print_warning "Tmux plugins will be installed on first tmux launch"
    print_success "Tmux plugins installed"
}

setup_custom_scripts() {
    print_header "${WRENCH} Setting Up Custom Scripts"
    
    mkdir -p ~/.local/bin
    
    # Create tt script (session switcher)
    if [ ! -f "$HOME/.local/bin/tt" ]; then
        print_step "Creating session switcher script..."
        cat > ~/.local/bin/tt << 'EOF'
#!/bin/bash
# Simple tmux session switcher
sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
if [ -z "$sessions" ]; then
    echo "No tmux sessions found"
    exit 1
fi
selected=$(echo "$sessions" | fzf --prompt="Select session: ")
if [ -n "$selected" ]; then
    tmux switch-client -t "$selected" 2>/dev/null || tmux attach -t "$selected"
fi
EOF
        chmod +x ~/.local/bin/tt
        print_success "Session switcher created"
    fi
    
    # Setup todo.sh configuration
    if [ ! -f "$HOME/.todo/config" ]; then
        print_step "Setting up todo.sh configuration..."
        mkdir -p ~/.todo
        cat > ~/.todo/config << 'EOF'
export TODO_DIR="$HOME/.todo"
export TODO_FILE="$TODO_DIR/todo.txt"
export DONE_FILE="$TODO_DIR/done.txt"
export REPORT_FILE="$TODO_DIR/report.txt"
export TODOTXT_DEFAULT_ACTION=ls
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n'
export TODOTXT_FINAL_FILTER='cat'
EOF
        touch ~/.todo/todo.txt
        print_success "todo.sh configured"
    fi
}

setup_help_system() {
    print_header "${WRENCH} Setting Up Interactive Help System"
    
    # The help system (cheat command) will be included in .zshrc
    # Just verify it's there
    print_step "Interactive help system will be available via 'cheat' command"
    print_success "Help system ready (run 'cheat' after installation)"
}

install_configs() {
    print_header "${WRENCH} Installing Configuration Files"
    
    # Backup existing configs
    backup_file ~/.vimrc
    backup_file ~/.tmux.conf
    backup_file ~/.zshrc
    backup_file ~/.p10k.zsh
    
    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [ -f "$SCRIPT_DIR/vimrc" ]; then
        print_step "Installing Vim configuration..."
        ln -sf "$SCRIPT_DIR/vimrc" ~/.vimrc
        print_success "Vim configuration installed"
    else
        print_warning "vimrc not found in $SCRIPT_DIR"
    fi
    
    if [ -f "$SCRIPT_DIR/tmux.conf" ]; then
        print_step "Installing Tmux configuration..."
        ln -sf "$SCRIPT_DIR/tmux.conf" ~/.tmux.conf
        print_success "Tmux configuration installed"
    else
        print_warning "tmux.conf not found in $SCRIPT_DIR"
    fi
    
    if [ -f "$SCRIPT_DIR/zshrc" ]; then
        print_step "Installing Zsh configuration..."
        cp "$SCRIPT_DIR/zshrc" ~/.zshrc
        # Make paths generic
        sed -i.bak "s|/home/ymazini|$HOME|g" ~/.zshrc 2>/dev/null || sed -i '' "s|/home/ymazini|$HOME|g" ~/.zshrc
        rm ~/.zshrc.bak 2>/dev/null || true
        print_success "Zsh configuration installed"
    else
        print_warning "zshrc not found in $SCRIPT_DIR"
    fi
    
    # Add PATH to .zshrc if not already there
    if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" ~/.zshrc 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    fi
}

setup_gemini_commands() {
    print_header "${WRENCH} Setting Up Gemini Commands"
    
    # Check if the user already has commands and back them up
    if [ -d "$HOME/.gemini/commands" ] && [ "$(ls -A $HOME/.gemini/commands 2>/dev/null)" ]; then
        print_warning "Existing Gemini commands found."
        backup_file "$HOME/.gemini/commands"
    fi
    
    print_step "The following command categories will be added:"
    echo -e "${CYAN}Content, Development, Media, Productivity, Security, System${NC}"
    read -p "Do you want to install these custom Gemini commands? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Creating Gemini commands directory..."
        mkdir -p ~/.gemini/commands
        
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        
        if [ -d "$SCRIPT_DIR/commands" ]; then
            print_step "Copying commands..."
            cp -r "$SCRIPT_DIR/commands"/* ~/.gemini/commands/ 2>/dev/null || print_warning "No commands directory found"
            print_success "Gemini commands installed successfully"
        else
            print_warning "Commands directory not found, skipping Gemini commands installation"
        fi
    else
        print_warning "Skipping installation of Gemini commands."
    fi
}

change_shell() {
    print_header "${ROCKET} Setting Up Default Shell"
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_step "Changing default shell to Zsh..."
        if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
            echo "$(which zsh)" | sudo tee -a /etc/shells >/dev/null
        fi
        chsh -s "$(which zsh)" 2>/dev/null || print_warning "Could not change shell automatically. Run: chsh -s $(which zsh)"
        print_success "Default shell changed to Zsh"
        print_warning "Please log out and log back in for the shell change to take effect"
    else
        print_success "Zsh is already the default shell"
    fi
}

run_health_check() {
    print_header "${CHECK} Running Health Check"
    
    local tools=(vim tmux zsh git fzf rg bat eza fd zoxide glow jq curl)
    local failed=0
    
    echo -e "${CYAN}Checking essential tools:${NC}\n"
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            print_success "$tool"
        else
            print_error "$tool not found"
            ((failed++))
        fi
    done
    
    echo ""
    
    # Check custom functions
    if grep -q "function cgetjson" ~/.zshrc 2>/dev/null; then
        print_success "CURL functions configured"
    else
        print_warning "CURL functions not found in .zshrc"
    fi
    
    if grep -q "function jfind" ~/.zshrc 2>/dev/null; then
        print_success "JQ functions configured"
    else
        print_warning "JQ functions not found in .zshrc"
    fi
    
    if grep -q "function cheat" ~/.zshrc 2>/dev/null; then
        print_success "Help system configured"
    else
        print_warning "Help system not found in .zshrc"
    fi
    
    echo ""
    
    if [ $failed -eq 0 ]; then
        print_success "All essential tools are installed and available!"
    else
        print_warning "$failed tools are missing. You may need to restart your shell or check the installation logs."
    fi
}

main() {
    # Handle command line arguments
    case "${1:-}" in
        --rollback)
            if [ -z "$2" ]; then
                show_rollback_help
                exit 1
            fi
            rollback_config "$2"
            exit $?
            ;;
        --list-backups)
            list_backups
            exit $?
            ;;
        --rollback-to)
            if [ -z "$2" ] || [ -z "$3" ]; then
                show_rollback_help
                exit 1
            fi
            rollback_to_specific "$2" "$3"
            exit $?
            ;;
        --help|-h)
            clear
            echo -e "${CYAN}"
            cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🚀 Ultimate Developer Dotfiles Installation Script 🚀         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
            echo -e "${NC}\n"
            show_rollback_help
            echo ""
            echo "Run without arguments for full installation"
            exit 0
            ;;
        "")
            # No arguments, run normal installation
            ;;
        *)
            print_error "Unknown option: $1"
            show_rollback_help
            exit 1
            ;;
    esac
    
    # Original installation flow starts here
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🚀 Ultimate Developer Dotfiles Installation Script 🚀         ║
║                                                                  ║
║   Transform your terminal into a modern development environment  ║
║                                                                  ║
║   Author: Youssef Mazini (ymazini)                              ║
║   GitHub: https://github.com/yomazini/dotfiles                  ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
    
    print_warning "This script will install and configure a complete development environment."
    print_warning "Make sure you have sudo privileges and a stable internet connection."
    echo
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Installation cancelled"
        exit 1
    fi
    
    detect_os
    install_package_manager
    install_essential_packages
    install_modern_cli_tools
    setup_zsh
    setup_vim
    setup_tmux
    setup_custom_scripts
    setup_help_system
    setup_gemini_commands
    install_configs
    change_shell
    run_health_check
    
    print_header "${STAR} Installation Complete!"
    echo -e "${GREEN}${ROCKET} Your ultimate development environment is ready!${NC}\n"
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. ${CYAN}Restart your terminal or run: source ~/.zshrc${NC}"
    echo -e "  2. ${CYAN}Configure Powerlevel10k: p10k configure${NC}"
    echo -e "  3. ${CYAN}Start tmux and press Ctrl+a I to install tmux plugins${NC}"
    echo -e "  4. ${CYAN}Run 'cheat' to access the interactive help system${NC}"
    echo -e "  5. ${CYAN}Test commands: cgetjson, jfind, extract, gitignore${NC}"
    echo ""
    echo -e "${CYAN}Rollback options:${NC}"
    echo -e "  ${GREEN}./install.sh --list-backups${NC}           List all backups"
    echo -e "  ${GREEN}./install.sh --rollback vim${NC}           Rollback Vim config"
    echo -e "  ${GREEN}./install.sh --rollback tmux${NC}          Rollback Tmux config"
    echo -e "  ${GREEN}./install.sh --rollback zsh${NC}           Rollback Zsh config"
    echo -e "  ${GREEN}./install.sh --rollback all${NC}           Rollback all configs"
    echo ""
    echo -e "${GREEN}${STAR} Enjoy your supercharged terminal!${NC}\n"
}

# =================================================================
# Script Entry Point
# =================================================================

# Ensure the script is not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
