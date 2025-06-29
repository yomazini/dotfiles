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
# Utilss Funs
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
                nodejs npm \
                clang clang-format clangd \
                fd-find ripgrep bat fzf \
                tree unzip jq
            
            # Ubuntu-specific: create symlinks for fd and bat
            if [ ! -L ~/.local/bin/fd ]; then
                mkdir -p ~/.local/bin
                ln -s /usr/bin/fdfind ~/.local/bin/fd
            fi
            if [ ! -L ~/.local/bin/bat ]; then
                ln -s /usr/bin/batcat ~/.local/bin/bat
            fi
            ;;
            
        macos)
            print_step "Installing essential packages..."
            brew install \
                curl wget git vim tmux zsh \
                cmake python3 \
                node npm \
                llvm \
                fd ripgrep bat fzf \
                tree jq
            ;;
            
        arch)
            print_step "Installing essential packages..."
            sudo pacman -S --noconfirm \
                curl wget git vim tmux zsh \
                base-devel cmake python python-pip \
                nodejs npm \
                clang \
                fd ripgrep bat fzf \
                tree unzip jq
            ;;
    esac
}

install_modern_cli_tools() {
    print_header "${ROCKET} Installing Modern CLI Tools"
    
    # if ur not sudo like us ==> {1337/42} student 😭 
	# just instead go to each part and download the releases in the github 
	# {tool you want to download and }/releases/ for ex: ==> https://github.com/junegunn/fzf/releases/ 
	 #Pro Tip: If you have a personal laptop, you can install the tools there
	# and just copy the final program files into your 42 machine's ~/.local/bin folder.
	# No laptop? You're a poor man? No worries, use GitHub Codespaces then 😉
	# The script below assumes you have `sudo`. If you installed everything
	# manually, you can just ignore any 'apt' errors it might show.
	# you do not have laptop you poor man no worries use Github Codespace then for sudo;


	# The script below will now proceed assuming 'sudo' is available.
	# script not 100% accurate try to download or give latest releases to Curl them 
    mkdir -p ~/.local/bin
    
    # Install Rust-based tools via cargo if available || otherwise use package manager.

    if command_exists cargo; then
        print_step "Installing Rust-based tools..."
        cargo install eza zoxide procs dysk
    else
        case $OS in
            ubuntu)
                # Install eza
                print_step "Installing eza..."
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
                sudo apt update
                sudo apt install -y eza
                
                # Install other tools
                install_if_missing "zoxide" "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
                ;;
                
            macos)
                brew install eza zoxide procs dysk
                ;;
                
            arch)
                sudo pacman -S --noconfirm eza zoxide
                install_if_missing "procs" "cargo install procs"
                install_if_missing "dysk" "cargo install dysk"
                ;;
        esac
    fi
    
    # Install Python tools
    print_step "Installing Python tools..."
    pip3 install --user autopep8 python-lsp-server pycodestyle pyfiglet
    
    # Install additional tools
    print_step "Installing additional CLI tools..."
    
    # glow (markdown viewer)
    install_if_missing "glow" "curl -sL https://github.com/charmbracelet/glow/releases/latest/download/glow_Linux_x86_64.tar.gz | tar -xz -C ~/.local/bin glow"
    
    # todo.sh
    if [ ! -f ~/.local/bin/todo.sh ]; then
        print_step "Installing todo.sh..."
        wget -O ~/.local/bin/todo.sh https://github.com/todotxt/todo.txt-cli/releases/latest/download/todo.txt_cli-2.12.0.tar.gz
        tar -xzf ~/.local/bin/todo.sh -C ~/.local/bin
        mv ~/.local/bin/todo.txt_cli-2.12.0/todo.sh ~/.local/bin/
        chmod +x ~/.local/bin/todo.sh
        rm -rf ~/.local/bin/todo.txt_cli-2.12.0 ~/.local/bin/todo.sh
        print_success "todo.sh installed"
    fi
    
    # tldr
    install_if_missing "tldr" "pip3 install --user tldr"
    
    # ranger
    install_if_missing "ranger" "pip3 install --user ranger-fm"
    
    # termdown
    install_if_missing "termdown" "pip3 install --user termdown"
    
    # viu (image viewer)
    install_if_missing "viu" "cargo install viu"
    
    # lazydocker
    if ! command_exists lazydocker; then
        print_step "Installing lazydocker..."
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi
    
    # mc (midnight commander)
    case $OS in
        ubuntu) sudo apt install -y mc ;;
        macos) brew install mc ;;
        arch) sudo pacman -S --noconfirm mc ;;
    esac
    
    # entr
    case $OS in
        ubuntu) sudo apt install -y entr ;;
        macos) brew install entr ;;
        arch) sudo pacman -S --noconfirm entr ;;
    esac
    
    # ipcalc
    case $OS in
        ubuntu) sudo apt install -y ipcalc ;;
        macos) brew install ipcalc ;;
        arch) sudo pacman -S --noconfirm ipcalc ;;
    esac
}

setup_zsh() {
    print_header "${ROCKET} Setting Up Zsh Environment"
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_step "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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
    vim +PlugInstall +qall
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
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    print_success "Tmux plugins installed"
}

setup_custom_scripts() {
    print_header "${WRENCH} Setting Up Custom Scripts"
    
    # Create tt script (session switcher) - this needs to be created based on your needs
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
    tmux switch-client -t "$selected"
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

install_configs() {
    print_header "${WRENCH} Installing Configuration Files"
    
    # Backup existing configs
    backup_file ~/.vimrc
    backup_file ~/.tmux.conf
    backup_file ~/.zshrc
    backup_file ~/.p10k.zsh
    
    # Create symlinks or copy configs
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [ -f "$SCRIPT_DIR/vimrc" ]; then
        print_step "Installing Vim configuration..."
        ln -sf "$SCRIPT_DIR/vimrc" ~/.vimrc
        print_success "Vim configuration installed"
    fi
    
    if [ -f "$SCRIPT_DIR/tmux.conf" ]; then
        print_step "Installing Tmux configuration..."
        ln -sf "$SCRIPT_DIR/tmux.conf" ~/.tmux.conf
        print_success "Tmux configuration installed"
    fi
    
    if [ -f "$SCRIPT_DIR/zshrc" ]; then
        print_step "Installing Zsh configuration..."
        # Make paths generic
        sed "s|/home/ymazini|$HOME|g" "$SCRIPT_DIR/zshrc" > ~/.zshrc.tmp
        mv ~/.zshrc.tmp ~/.zshrc
        print_success "Zsh configuration installed"
    fi
}

change_shell() {
    print_header "${ROCKET} Setting Up Default Shell"
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_step "Changing default shell to Zsh..."
        if ! grep -q "$(which zsh)" /etc/shells; then
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi
        chsh -s "$(which zsh)"
        print_success "Default shell changed to Zsh"
        print_warning "Please log out and log back in for the shell change to take effect"
    else
        print_success "Zsh is already the default shell"
    fi
}

run_health_check() {
    print_header "${CHECK} Running Health Check"
    
    local tools=(vim tmux zsh git fzf rg bat eza fd zoxide glow)
    local failed=0
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            print_success "$tool"
        else
            print_error "$tool not found"
            ((failed++))
        fi
    done
    
    if [ $failed -eq 0 ]; then
        print_success "All essential tools are installed and available!"
    else
        print_warning "$failed tools are missing. You may need to restart your shell or check the installation logs."
    fi
}

main() {
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
    install_configs
    change_shell
    run_health_check
    
    print_header "${STAR} Installation Complete!"
    echo -e "${GREEN}${ROCKET} Your ultimate development environment is ready!${NC}\n"
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. ${CYAN}Restart your terminal or run: source ~/.zshrc${NC}"
    echo -e "  2. ${CYAN}Configure Powerlevel10k: p10k configure${NC}"
    echo -e "  3. ${CYAN}Start tmux and press"
}

# =================================================================
# Script Entry Point
# =================================================================

# Ensure the script is not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

