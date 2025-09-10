# 🚀 Ultimate Developer Dotfiles

> A modern, powerful, and beautifully crafted development environment setup featuring Vim, Tmux, and Zsh configurations optimized for productivity and aesthetics.

 - 📄 **The Visual Playbook: 10x Productivity For Software Engineers** [Get it here](https://github.com/yomazini/dotfiles/blob/main/The%20Visual%20Playbook%20Developer-Productivity-Playbook.pdf)
 - ⚡ **Read Also My Article : The Hidden Psychology of Great Developers** [Get it here](https://medium.com/@mazini/the-hidden-psychology-of-elite-developers-why-your-environment-is-everything-6d0a475e354e)

## ✨ Features

### 🎨 **Beautiful Gruvbox Theme Everywhere**
- Consistent dark theme across Vim, Tmux, and terminal
- Eye-friendly color scheme perfect for long coding sessions
- Carefully crafted status bars and UI elements

### ⚡ **Supercharged Vim IDE**
- **Language Support**: C/C++, Python, JavaScript, and more
- **Smart Autocompletion** with ALE (Asynchronous Lint Engine)
- **File Explorer** with NERDTree and icons
- **Fuzzy Finding** with CtrlP
- **Git Integration** with GitGutter
- **Code Formatting** and linting
- **Quick Commands** for common tasks

### 🖥️ **Powerful Tmux Setup**
- **Vim-like Navigation** between panes
- **Session Management** with custom scripts
- **Beautiful Status Bar** with system info
- **Plugin Management** with TPM
- **Session Persistence** (resurrect & continuum)
- **Copy Mode** optimized for productivity

### 🐚 **Modern Zsh Environment**
- **Powerlevel10k** prompt with instant loading
- **Oh My Zsh** with carefully selected plugins
- **Modern CLI Tools** (eza, bat, ripgrep, fzf, zoxide)
- **Git Workflow** enhancement functions
- **Productivity Aliases** and functions
- **Interactive Tools** for file management

### 🤖 **AI-Powered Gemini Commands**
- **Automate & Enhance**: Go beyond aliases with powerful, pre-configured prompts for Gemini.
- **Expert Personas**: Generate high-quality code, documentation, summaries, and more with a single command.
- **Streamlined Workflow**: Integrate advanced AI capabilities directly into your terminal.

## 🛠️ What's Included

### 📁 Configuration Files
- **`.vimrc`** - Complete Vim IDE setup
- **`.tmux.conf`** - Feature-rich Tmux configuration  
- **`.zshrc`** - Modern shell environment with productivity tools

### 🔧 Essential Tools
```
Development Tools:
├── autopep8          # Python code formatter
├── clangd           # C/C++ language server
├── pylsp            # Python language server
└── pycodestyle      # Python style checker

File & Navigation:
├── bat              # Modern cat with syntax highlighting
├── eza              # Modern ls replacement
├── fd               # Modern find replacement
├── rg (ripgrep)     # Ultra-fast grep replacement
├── fzf              # Fuzzy finder
├── zoxide           # Smart cd replacement
└── ranger           # Terminal file manager

System & Productivity:
├── glow             # Markdown viewer
├── procs            # Modern ps replacement
├── dysk             # Disk usage analyzer
├── lazydocker       # Docker TUI
├── termdown         # Terminal countdown timer
├── tldr             # Simplified man pages
├── todo.sh          # Command-line todo manager
└── viu              # Terminal image viewer

Development Utilities:
├── entr             # File watcher
├── ipcalc           # IP calculator
├── mc               # Midnight Commander
├── starship         # Cross-shell prompt
└── unp              # Universal unpacker
```

## 🚀 Quick Start

### 1️⃣ **One-Line Installation**
```bash
curl -fsSL https://raw.githubusercontent.com/yomazini/dotfiles/main/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

### 2️⃣ **Manual Installation**
```bash
# Clone the repository
git clone https://github.com/yomazini/dotfiles.git
cd dotfiles

# Run the installation script
chmod +x install.sh
./install.sh
```

### 3️⃣ **What the installer does:**
- 🔄 Backs up your existing configurations
- 📦 Installs all required tools and dependencies
- 🔗 Creates symbolic links to the new configurations
- 🎨 Sets up plugins and themes
- ✅ Verifies the installation

## 📖 Usage Guide

### 🎯 **Vim IDE Commands**

| Command | Description |
|---------|-------------|
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>wq` | Save and quit |
| `<Space>j` | Format JSON |
| `<Space>d` | Show error details |
| `Ctrl+n` | Toggle file tree |
| `Ctrl+p` | Fuzzy file search |
| `:Format` | Auto-format code |
| `:GStatus` | Git status in split |

### 🖥️ **Tmux Power User Commands**

| Command | Description |
|---------|-------------|
| `Ctrl+a` | Prefix key |
| `Ctrl+a r` | Reload config |
| `Ctrl+a e` | Edit config |
| `Ctrl+a "` | Horizontal split |
| `Ctrl+a %` | Vertical split |
| `Ctrl+a hjkl` | Navigate panes |
| `Ctrl+a HJKL` | Resize panes |
| `Ctrl+a j` | Session switcher |
| `Ctrl+a R` | Renumber windows |

### 🐚 **Zsh Productivity Shortcuts**

#### Git Workflow
```bash
gia        # Interactive git add with preview
gco        # Interactive branch checkout
glo        # Beautiful git log with fzf
gs         # Git status
gd         # Git diff
```

#### File Operations
```bash
vf         # Find and edit file with fzf
cf         # Find and view file with fzf
fgr        # Find in files and open in editor
del        # Interactive file deletion
mkcd dir   # Create and enter directory
```

#### Modern CLI
```bash
ll         # Detailed file listing with icons
tree       # Directory tree view
cat file   # Syntax highlighted file view
grep text  # Fast search with ripgrep
cd dir     # Smart directory jumping with zoxide
```

#### System & Productivity
```bash
todo       # Find TODO/FIXME in code
port 3000  # Check what's using a port
weather    # Get weather forecast
cpy file   # Copy to clipboard
dark_mode  # Switch to dark theme
```

### 🤖 Gemini Commands

These custom commands are designed to integrate the power of Google's Gemini directly into your command-line workflow, turning simple prompts into powerful, structured outputs. By using expert personas and predefined templates, they streamline common tasks, automate complex processes, and ensure high-quality, consistent results for everything from writing code to summarizing meetings.

The following custom commands are included to supercharge your workflow with Gemini. They are automatically installed into `~/.gemini/commands`.

| Command Category | Command Name | Description |
| :--- | :--- | :--- |
| **Content** | `content-summarize` | Provides a multi-format summary of any text. |
| | `email-draft` | Drafts professional emails based on context, tone, and purpose. |
| | `meeting-summary` | Summarizes meeting notes into actionable insights. |
| | `prompt-enhance` | Refines a raw user prompt into a highly effective instruction. |
| | `report-gen` | Generates comprehensive reports from data files. |
| **Development** | `code-refactor` | Refactors a piece of code based on a specific instruction. |
| | `debug-assistant` | Analyzes error logs and provides systematic debugging strategies. |
| | `doc-generate` | Generates professional, language-aware documentation for code. |
| | `docker-explain` | Explains a Dockerfile or docker-compose.yml in plain English. |
| | `git-commit` | Generates a Conventional Commit message from staged changes. |
| | `git-summarize` | Summarizes a git log into a human-readable changelog. |
| | `test-create` | Generates a complete, runnable test file for the provided code. |
| | `test-gen` | Automatically generates comprehensive test cases. |
| | `test-report` | Analyzes a test failure report and suggests fixes. |
| **Media** | `photo-rename` | Organizes and renames photos based on visual content and metadata. |
| **Productivity**| `flashcards-create` | Generates a set of 10 technical flashcards for Anki. |
| | `local-weather` | Provides a clean, natural-language summary of the weather. |
| | `search-advanced` | Activates an advanced search agent for up-to-date information. |
| | `task-prioritizer` | Creates organized, actionable task lists with time estimates. |
| | `ticket-create` | Formats a simple description into a structured bug report or ticket. |
| **Security** | `security-audit` | Performs a comprehensive security audit of code and dependencies. |
| **System** | `apt-find` | Searches APT repositories using natural language. |
| | `cleanup` | Identifies and suggests cleanup opportunities in a codebase. |
| | `file-organizer` | Intelligently organizes files in directories. |
| | `sys-health-check` | Provides a quick summary of system health (disk, memory, CPU). |
| | `sys-search` | Translates a natural language query into a ripgrep command. |

## 🎨 Customization

### 🎭 **Changing Themes**
All configurations use the **Gruvbox** theme for consistency. To change:

**Vim**: Edit `.vimrc` and change `colorscheme gruvbox`
```vim
colorscheme your-theme-name
```

**Tmux**: Edit the color variables in `.tmux.conf`
```bash
bg1='#your-bg-color'
fg='#your-fg-color'
yellow='#your-accent-color'
```

### ⌨️ **Custom Key Bindings**
Add your own shortcuts to `.vimrc`:
```vim
nnoremap <leader>your-key :YourCommand<CR>
```

Or to `.tmux.conf`:
```bash
bind your-key your-command
```

### 🔧 **Adding Tools**
To add new CLI tools, edit `install.sh` and `.zshrc`:

1. Add installation command to `install.sh`
2. Add aliases/functions to `.zshrc`
3. Re-run the installer

## 🔧 Troubleshooting

### Common Issues

**🐍 Python Tools Not Working?**
```bash
# Ensure Python and pip are installed
python3 --version
pip3 --version

# Reinstall Python tools
pip3 install --user autopep8 python-lsp-server pycodestyle
```

**🎨 Colors Not Showing?**
```bash
# Check terminal color support
echo $TERM
# Should show: screen-256color or xterm-256color

# Test colors
curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

**🔌 Vim Plugins Failing?**
```bash
# Reinstall vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Reinstall plugins
vim +PlugInstall +qall
```

**📦 Tmux Plugins Not Loading?**
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins: Ctrl+a + I
```

### 🩺 Health Check
Run this to verify your setup:
```bash
# Check essential tools
for tool in vim tmux zsh git fzf rg bat eza fd zoxide; do
    command -v $tool >/dev/null 2>&1 && echo "✅ $tool" || echo "❌ $tool"
done
```

## 🤝 Contributing

Found a bug or have a suggestion? Contributions are welcome!

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to the branch: `git push origin amazing-feature`
5. **Open** a Pull Request

## 🙏 Acknowledgments

- **Oh My Zsh** community for the amazing framework
- **Vim** and **Tmux** communities for the incredible tools
- **1337 / 42 School** for the inspiration and learning environment

## 🎭 Author

Made with ☕️ and perseverance by **Youssef Mazini** (ymazini)

- 🎓 42 Intra: [ymazini](https://profile.intra.42.fr/users/ymazini)
- 🐙 GitHub: [yomazini](https://github.com/yomazini)
- 💼 LinkedIn: [Connect with me](https://www.linkedin.com/in/youssef-mazini/)

---

<div align="center">

**⭐ Star this repo if it helped you! ⭐**

*Built for developers, by developers* 🚀

</div>
