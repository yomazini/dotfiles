
# -- Powerlevel10k Instant Prompt (MUST be at the very top) --
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- PATH Configuration --
# This ensures all your locally installed programs are found first.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# (Keeping your custom .capt paths from your original file)
#export PATH="/home/$USER/.capt:/home/$USER/.capt/root/usr/local/sbin:/home/$USER/.capt/root/usr/local/bin:/home/$USER/.capt/root/usr/sbin:/home/$USER/.capt/root/usr/bin:/home/$USER/.capt/root/sbin:/home/$USER/.capt/root/bin:/home/$USER/.capt/root/usr/games:/home/$USER/.capt/root/usr/local/games:/home/$USER/.capt/snap/bin:$PATH"
#export LD_LIBRARY_PATH="/home/$USER/.capt/root/lib/x86_64-linux-gnu:/home/$USER/.capt/root/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

# -- Oh My Zsh Configuration --
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git sudo history docker zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)
source $ZSH/oh-my-zsh.sh

# -- Shell Settings --
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
export EDITOR='vim'
export LANG=en_US.UTF-8

# -- Your Custom Aliases & Functions --
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias gs="git status"
alias gd="git diff"
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"
alias h="history"
alias valgrind_all='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias sanitize_all='clang -g -O1 -fsanitize=address -fno-omit-frame-pointer -o sancheck.out'
#alias readline_path="echo '-I$HOME/readline/include -L$HOME/readline/lib -lreadline -lncurses'"
alias cclean='bash ~/Cleaner_42.sh'
#alias mstest="bash ~/42_minishell_tester/tester.sh"
alias fkill="ps -ef | fzf | awk '{print \$2}' | xargs kill -9"
alias r="ranger"
alias ocr="~/.local/bin/gnome-ocr-area.sh"

alias v="vim"
alias md='glow -p'

dark_mode() {
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
}



# ===========================

alias cdwn='curl -L -C - -O'
alias cdown='curl -L -C - -o'
alias cks='curl -L -k'
alias chead='curl -I -L'
alias cverb='curl -v -L'
function cgetjson() {
    [ -z "$1" ] && { echo "Usage: cgetjson <URL>"; return 1; }
    curl -s -L -H "Accept: application/json" "$1" | jq .
}

function cpost() {
    [ -z "$2" ] && { echo "Usage: cpost <URL> <DATA_OR_FILE>"; return 1; }
    [[ "$2" == @* ]] && curl -X POST -s -L -H "Content-Type: application/json" -d "$2" "$1" | jq . || curl -X POST -s -L -H "Content-Type: application/json" -d "$2" "$1" | jq .
}

function cput() {
    [ -z "$2" ] && { echo "Usage: cput <URL> <DATA_OR_FILE>"; return 1; }
    [[ "$2" == @* ]] && curl -X PUT -s -L -H "Content-Type: application/json" -d "$2" "$1" | jq . || curl -X PUT -s -L -H "Content-Type: application/json" -d "$2" "$1" | jq .
}

function cdel() {
    [ -z "$1" ] && { echo "Usage: cdel <URL>"; return 1; }
    curl -X DELETE -s -L "$1" | jq .
}

function cresolve() {
    [ -z "$3" ] && { echo "Usage: cresolve <DOMAIN> <IP:PORT> <URL>"; return 1; }
    curl -v -L --resolve "$1:${2##*:}:$2" "$3"
}

function chost() {
    [ -z "$2" ] && { echo "Usage: chost <HOST_HEADER> <URL>"; return 1; }
    curl -v -L -H "Host: $1" "$2"
}

function cauth() {
    [ -z "$3" ] && { echo "Usage: cauth <USER> <PASS> <URL>"; return 1; }
    curl -v -L -u "$1:$2" "$3"
}


# ===========================

alias jqp='jq .'
alias jqk='jq keys'
alias jql='jq length'

function jval() {
    [ -z "$1" ] && { echo "Usage: ... | jval <KEY>"; return 1; }
    jq -r ".$1"
}

function jfield() {
    [ -z "$1" ] && { echo "Usage: ... | jfield <KEY>"; return 1; }
    jq -r '.[].'$1
}

function jfields() {
    [ $# -eq 0 ] && { echo "Usage: ... | jfields <KEY1> <KEY2> ..."; return 1; }
    local query_parts=""
    for key in "$@"; do query_parts+=".$key, "; done
    jq -r '.[] | ['"${query_parts%, }"'] | @tsv' | column -t
}

function jfind() {
    if [ -z "$2" ]; then
        echo "Usage: ... | jfind <KEY> <VALUE>"
        echo "       ... | jfind <KEY> <VALUE> --contains  (for partial match)"
        return 1
    fi
    
    local key="$1"
    local value="$2"
    local mode="${3:-exact}"
    
    if [[ "$mode" == "--contains" || "$3" == "-c" ]]; then
        # Partial match (contains)
        jq --arg k "$key" --arg v "$value" '
            if type == "array" then
                map(select(.[$k] | tostring | contains($v)))
            else
                select(.[$k] | tostring | contains($v))
            end
        '
    else
        # Exact match
        jq --arg k "$key" --arg v "$value" '
            if type == "array" then
                map(select(.[$k] == $v))
            else
                select(.[$k] == $v)
            end
        '
    fi
}


alias ...='cd ../../..'
alias gp='git push'
alias gl='git pull'
alias gc='git commit'
alias ~='cd ~'

# ===========================


function extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <archive_file>"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "Error: '$1' is not a valid file"
        return 1
    fi
    
    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.tar.xz)    tar xJf "$1"     ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)           echo "Error: '$1' cannot be extracted via extract()" ;;
    esac
}

# Usage: extract archive.tar.gz


function gitignore() {
    if [ -z "$1" ]; then
        echo "Usage: gitignore <language/framework>"
        echo "Examples: gitignore python, gitignore node, gitignore c"
        return 1
    fi
    
    local lang=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    curl -sL "https://www.toptal.com/developers/gitignore/api/$lang" -o .gitignore
    
    if [ $? -eq 0 ]; then
        echo "✅ .gitignore created for: $1"
        echo "📄 Preview:"
        head -20 .gitignore
    else
        echo "❌ Failed to generate .gitignore for: $1"
    fi
}

# Usage: gitignore python
# Usage: gitignore c,vim,linux


function backup() {
    if [ -z "$1" ]; then
        echo "Usage: backup <file_or_directory>"
        return 1
    fi
    
    if [ ! -e "$1" ]; then
        echo "Error: '$1' does not exist"
        return 1
    fi
    
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_name="${1}_backup_${timestamp}"
    
    if [ -d "$1" ]; then
        cp -r "$1" "$backup_name"
        echo "✅ Directory backed up: $backup_name"
    else
        cp "$1" "$backup_name"
        echo "✅ File backed up: $backup_name"
    fi
    
    # Show backup size
    du -sh "$backup_name" 2>/dev/null | awk '{print "📦 Size: " $1}'
}

# Usage: backup important_file.c
# Usage: backup my_project/
# Creates: important_file.c_backup_20250103_143022


function serve() {
    local port="${1:-8000}"
    
    echo "🌐 Starting HTTP server on port $port"
    echo "📂 Serving: $(pwd)"
    echo "🔗 Access at: http://localhost:$port"
    echo "⏹️  Press Ctrl+C to stop"
    echo ""
    
    # Try Python 3 first, then Python 2, then PHP
    if command -v python3 &>/dev/null; then
        python3 -m http.server "$port"
    elif command -v python &>/dev/null; then
        python -m SimpleHTTPServer "$port"
    elif command -v php &>/dev/null; then
        php -S "localhost:$port"
    else
        echo "❌ Error: No server found (install python3)"
        return 1
    fi
}

# Usage: serve          # Starts on port 8000
# Usage: serve 3000     # Starts on port 3000

function pfind() {
    local pid
    
    # Show all processes with nice formatting, let user pick
    pid=$(ps aux | sed 1d | fzf --multi --header="[SELECT PROCESS]" | awk '{print $2}')
    
    if [ -z "$pid" ]; then
        echo "No process selected"
        return 0
    fi
    
    echo "Selected PID(s): $pid"
    echo ""
    echo "Actions:"
    echo "  1) Show details"
    echo "  2) Kill (SIGTERM)"
    echo "  3) Force kill (SIGKILL)"
    echo "  4) Cancel"
    echo ""
    read -p "Choose action [1-4]: " action
    
    case $action in
        1)
            echo "$pid" | xargs -I {} ps -p {} -f
            ;;
        2)
            echo "$pid" | xargs kill
            echo "✅ Sent SIGTERM to process(es)"
            ;;
        3)
            echo "$pid" | xargs kill -9
            echo "✅ Force killed process(es)"
            ;;
        *)
            echo "Cancelled"
            ;;
    esac
}

# Usage: pfind
# Then type to search: "node", "python", "vim", etc.


# Cat all files based on extenstion or none for all in dir and subdir

cat_exts() {
  # If no extensions are provided, assume all files are desired.
  if [ $# -eq 0 ]; then
    find . -type f -print0 | xargs -0 cat
    return 0
  fi

  local find_args=()
  local first_ext=1
  for ext in "$@"; do
    # Add a leading dot if it's missing (e.g., 'py' becomes '.py')
    if [[ "${ext:0:1}" != "." ]]; then
      ext=".${ext}"
    fi

    if [[ "$first_ext" -eq 1 ]]; then
      find_args+=( -name "*${ext}" )
      first_ext=0
    else
      find_args+=( -o -name "*${ext}" )
    fi
  done

  # find . -type f ( -name "*.py" -o -name "*.md" ) ...
  find . -type f \( "${find_args[@]}" \) -print0 | xargs -0 cat
}




# ============================================================
# SUPER USEFUL QUICK ALIASES
# ============================================================

# File operations
alias cpv='rsync -ah --info=progress2'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'

# Development
alias npmls='npm list --depth=0'
alias pipls='pip list --format=columns'
alias venv='python3 -m venv venv && source venv/bin/activate'

# Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dstop='docker stop $(docker ps -q)'
alias dclean='docker system prune -af'


# ===========================




# -- Task Management --
alias tda='todo.sh add'      # Quickly add a new task
alias tdl='todo.sh list | sort'     # List all pending tasks
alias tdd='todo.sh done'     # Mark a task as done by its number
alias tdr='todo.sh del'      # Remove a task by its number
alias tdp='todo.sh pri'      # Set priority for a task

# better to add fonts of the  "Fira Fonts"
alias ls='eza --icons --git'
alias ll='eza -l --long --header --icons --git'
alias la='eza -a --icons --git'
alias tree='eza --tree'

# Show large directories (>10MB) including hidden ones, sorted by size from biggger to smalr 
alias bigdirs='du -sh ~/.[^.]* ~/* 2>/dev/null | awk '\''$1 ~ /^[1-9][0-9]+M$|^[0-9]+G$|^[0-9]+T$/'\'' | sort -hr'

# Show large files (>10MB) with human readable sizes
alias bigfiles='find ~ -type f -size +10M -printf "%s %p\n" 2>/dev/null | awk '\''{size=$1/(1024*1024); printf "%.1fM %s\n", size, substr($0, index($0,$2))}'\'' | sort -nr'

# Show both large directories & files (comprehensive view)
alias bigstuff='echo "=== LARGE DIRECTORIES ===" && bigdirs && echo -e "\n=== LARGE FILES ===" && bigfiles'

# Show disk usage of current directory contents (including hidden alsoo)
alias duh='du -sh .[^.]* * 2>/dev/null | sort -hr'

# Show top 10 largest items in current directory
alias du10='du -sh .[^.]* * 2>/dev/null | sort -hr | head -10'

alias cat='bat -p --paging=never'
alias grep='rg'
alias cd='z'
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -- Find & Edit file with fzf and vim
vf() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
    if [[ -n $file ]]; then
        vim "$file"
    fi
}

cf() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
      if [[ -n $file ]]; then
          cat "$file"
      fi
}

# smarter grep function
fgr() {
    local selected
    selected=$(rg --line-number --color=always '' | fzf --ansi)
    if [[ -z "$selected" ]]; then
        return 0
    fi
    local file
    local line
    file=$(echo "$selected" | cut -d ':' -f 1)
    line=$(echo "$selected" | cut -d ':' -f 2)
    if [[ -n "$file" && -n "$line" ]]; then
        vim "+$line" "$file"
    fi
}

# --- Git Workflow Enhancement ---

gia() {
    local files_to_add
    files_to_add=$(git -c color.status=always status --short | \
        fzf -m --ansi --preview 'bat --color=always {+2}')
    if [[ -n "$files_to_add" ]]; then
        echo "$files_to_add" | awk '{print $2}' | xargs git add
        git status
    fi
}

# 2. Interactive Git Checkout (`gco`)
unalias gco
gco() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD | sed 's/remotes\/origin\///g' | sed 's/^\s*//g' | sort | uniq)
    branch=$(echo "$branches" | fzf-tmux -d 20 --prompt="Checkout branch: ")
    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    fi
}

# 3. Interactive Git Log (`glo`)
unalias glo
glo() {
    git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(bold blue)%d%Creset %s %Cgreen(%cr) %C(bold magenta)<%an>%Creset' --abbrev-commit | fzf --ansi --no-sort --reverse --preview 'git show --color=always {1}'
}

# --- Smarter File & Directory Management ---

# 4. Make Directory and cd Into It (`mkcd`)
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 5. Find and Edit Recent Files (`fer`)
fer() {
    local file
    file=$(find . -type f -mtime -1 | fzf --preview 'bat --color=always {}')
    if [[ -n "$file" ]]; then
        vim "$file"
    fi
}

# Usage: <command> | cpy   OR   cpy <filename>
cpy() {
  # Use an array for the command and its arguments
  local copy_cmd
  # Detect the correct copy command for the OS
  if command -v xclip >/dev/null 2>&1; then
    # Store command and arguments separately in an array
    copy_cmd=('xclip' '-selection' 'clipboard')
  elif command -v pbcopy >/dev/null 2>&1; then
    copy_cmd=('pbcopy') # For macOS
  else
    echo "❌ Error: No clipboard tool (xclip, pbcopy) found."
    return 1
  fi
  # Check if data is being piped in or given as a file argument
  if [ -t 0 ]; then
    # No piped data, treat arguments as filenames
    if [ $# -eq 0 ]; then
      echo "📋 Usage: <command> | cpy   OR   cpy <filename>"
      return 1
    fi
    # Execute the command correctly from the array
    cat "$@" | "${copy_cmd[@]}"
    echo "✅ Copied content of file: $@"
  else
    # Data is being piped in from another command
    # Execute the command correctly from the array
    "${copy_cmd[@]}"
    echo "✅ Copied piped output to clipboard."
  fi
}

port() {
    lsof -i :"$1"
}

weather() {
    curl wttr.in/Khouribga
}

del() {
    # The -0 flags tell fd, fzf, and xargs to use a special character (null)
    fd --type f --hidden --exclude .git -0 | \
        fzf -m --read0 --preview 'bat --color=always {}' | \
        xargs -0 -r rm -v
}

# 5. Find all TODOs and FIXMEs ('todo')
alias todo='rg --color=always -i "(todo|fixme)"'

alias update="sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh && flatpak update -y && sudo aptitude update && sudo aptitude safe-upgrade -y "


# ============================================================
# INTERACTIVE TERMINAL CHEATSHEET & HELP SYSTEM
# ============================================================
# Usage: cheat [category] or just 'cheat' for interactive menu

cheat() {
    local category="${1:-menu}"
    
    # Color definitions
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local MAGENTA='\033[0;35m'
    local CYAN='\033[0;36m'
    local WHITE='\033[1;37m'
    local BOLD='\033[1m'
    local NC='\033[0m' # No Color
    
    show_header() {
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔════════════════════════════════════════════════════════════════╗"
        echo "║                                                                ║"
        echo "║            🚀 TERMINAL PRODUCTIVITY CHEATSHEET 🚀              ║"
        echo "║                                                                ║"
        echo "╚════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}\n"
    }
    
    show_menu() {
        show_header
        echo -e "${WHITE}${BOLD}Select a category:${NC}\n"
        echo -e "${GREEN}  1)${NC} CURL & API Testing"
        echo -e "${GREEN}  2)${NC} JQ JSON Processing"
        echo -e "${GREEN}  3)${NC} Essential Functions"
        echo -e "${GREEN}  4)${NC} TMUX Commands"
        echo -e "${GREEN}  5)${NC} VIM Commands"
        echo -e "${GREEN}  6)${NC} Git Workflow"
        echo -e "${GREEN}  7)${NC} File Operations"
        echo -e "${GREEN}  8)${NC} System Monitoring"
        echo -e "${GREEN}  9)${NC} Docker Utilities"
        echo -e "${GREEN} 10)${NC} All Commands (Searchable)"
        echo -e "${GREEN}  0)${NC} Exit"
        echo ""
        echo -n "Enter choice [0-10]: "
        read choice
        
        case $choice in
            1) show_curl ;;
            2) show_jq ;;
            3) show_essential ;;
            4) show_tmux ;;
            5) show_vim ;;
            6) show_git ;;
            7) show_files ;;
            8) show_system ;;
            9) show_docker ;;
            10) search_all ;;
            0) return ;;
            *) echo "Invalid choice"; sleep 1; show_menu ;;
        esac
    }
    
    
  show_curl() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ CURL & API TESTING ═══${NC}\n"
    
    echo -e "${CYAN}Basic Aliases:${NC}"
    echo -e "  ${GREEN}c${NC}         curl                          Quick curl shorthand"
    echo -e "  ${GREEN}cdwn${NC}      curl -L -C - -O               Resumable download"
    echo -e "  ${GREEN}chead${NC}     curl -I -L                    Fetch headers only"
    echo -e "  ${GREEN}cverb${NC}     curl -v -L                    Verbose debugging"
    
    echo -e "\n${CYAN}API Testing Functions:${NC}"
    echo -e "  ${GREEN}cgetjson <url>${NC}                GET JSON with pretty print"
    echo -e "  ${GREEN}cpost <url> <data>${NC}            POST JSON data"
    echo -e "  ${GREEN}cput <url> <data>${NC}             PUT JSON data"
    echo -e "  ${GREEN}cdel <url>${NC}                    DELETE request"
    
    echo -e "\n${CYAN}Advanced Network:${NC}"
    echo -e "  ${GREEN}cresolve <domain> <ip:port> <url>${NC}    Test DNS override"
    echo -e "  ${GREEN}chost <header> <url>${NC}                  Override Host header"
    echo -e "  ${GREEN}cauth <user> <pass> <url>${NC}             Test basic auth"
    
    echo -e "\n${MAGENTA}Examples:${NC}"
    echo -e "  ${BLUE}cgetjson https://api.github.com/users/yomazini${NC}"
    echo -e "  ${BLUE}cpost https://api.test.com/users '{\"name\":\"John\"}'${NC}"
    echo -e "  ${BLUE}chead https://example.com${NC}"
    
    pause_menu
}

show_jq() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ JQ JSON PROCESSING ═══${NC}\n"
    
    echo -e "${CYAN}Basic Aliases:${NC}"
    echo -e "  ${GREEN}jqp${NC}       jq .                          Pretty print JSON"
    echo -e "  ${GREEN}jqk${NC}       jq keys                       List all keys"
    echo -e "  ${GREEN}jql${NC}       jq length                     Count items"
    
    echo -e "\n${CYAN}Helper Functions:${NC}"
    echo -e "  ${GREEN}... | jval <key>${NC}                      Extract single value"
    echo -e "  ${GREEN}... | jfield <key>${NC}                    Extract field from array"
    echo -e "  ${GREEN}... | jfields <k1> <k2> ...${NC}           Extract multiple fields as table"
    echo -e "  ${GREEN}... | jfind <key> <value>${NC}             Filter by exact match"
    echo -e "  ${GREEN}... | jfind <key> <val> -c${NC}            Filter by contains (partial)"
    
    echo -e "\n${MAGENTA}Examples:${NC}"
    echo -e "  ${BLUE}cgetjson <url> | jval status${NC}"
    echo -e "  ${BLUE}cgetjson <url> | jfield id${NC}"
    echo -e "  ${BLUE}cgetjson <url> | jfields name email status${NC}"
    echo -e "  ${BLUE}cgetjson <url> | jfind language \"C\"${NC}"
    echo -e "  ${BLUE}cgetjson <url> | jfind body \"error\" -c${NC}"
    
    pause_menu
}

show_essential() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ ESSENTIAL FUNCTIONS ═══${NC}\n"
    
    echo -e "${CYAN}Top 5 Daily Functions:${NC}"
    echo -e "  ${GREEN}extract <archive>${NC}              Universal archive extractor"
    echo -e "  ${GREEN}gitignore <language>${NC}           Generate .gitignore file"
    echo -e "  ${GREEN}backup <file/dir>${NC}              Create timestamped backup"
    echo -e "  ${GREEN}serve [port]${NC}                   Start HTTP server (default: 8000)"
    echo -e "  ${GREEN}pfind${NC}                          Interactive process finder/killer"
    
    echo -e "\n${CYAN}Additional Utilities:${NC}"
    echo -e "  ${GREEN}cat_exts [.ext ...]${NC}            Cat all files by extension"
    echo -e "  ${GREEN}mkcd <dir>${NC}                     Make directory and cd into it"
    echo -e "  ${GREEN}port <number>${NC}                  Check what's using a port"
    echo -e "  ${GREEN}weather${NC}                        Get weather forecast"
    echo -e "  ${GREEN}myip${NC}                           Get your public IP"
    
    echo -e "\n${MAGENTA}Examples:${NC}"
    echo -e "  ${BLUE}extract project.tar.gz${NC}"
    echo -e "  ${BLUE}gitignore c,vim,linux${NC}"
    echo -e "  ${BLUE}backup important_file.c${NC}"
    echo -e "  ${BLUE}serve 3000${NC}"
    echo -e "  ${BLUE}port 8080${NC}"
    
    pause_menu
}

show_tmux() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ TMUX COMMANDS ═══${NC}\n"
    
    echo -e "${CYAN}Session Management:${NC}"
    echo -e "  ${GREEN}t <n>${NC}              Create/attach to session"
    echo -e "  ${GREEN}Ctrl+a j${NC}          Pop-up session switcher"
    echo -e "  ${GREEN}Ctrl+a d${NC}          Detach from session"
    echo -e "  ${GREEN}tmux ls${NC}            List all sessions"
    
    echo -e "\n${CYAN}Window Management:${NC}"
    echo -e "  ${GREEN}Ctrl+a c${NC}          Create new window"
    echo -e "  ${GREEN}Ctrl+a ,${NC}          Rename window"
    echo -e "  ${GREEN}Ctrl+a n/p${NC}        Next/Previous window"
    echo -e "  ${GREEN}Ctrl+a 1-9${NC}        Jump to window number"
    
    echo -e "\n${CYAN}Pane Management:${NC}"
    echo -e "  ${GREEN}Ctrl+a %${NC}          Vertical split"
    echo -e "  ${GREEN}Ctrl+a \"${NC}          Horizontal split"
    echo -e "  ${GREEN}Ctrl+a h/j/k/l${NC}    Navigate panes (vim-style)"
    echo -e "  ${GREEN}Ctrl+a H/J/K/L${NC}    Resize panes"
    echo -e "  ${GREEN}Ctrl+a z${NC}          Zoom pane (toggle fullscreen)"
    
    echo -e "\n${CYAN}Copy Mode:${NC}"
    echo -e "  ${GREEN}Ctrl+a [${NC}          Enter copy mode"
    echo -e "  ${GREEN}v${NC}                  Begin selection (in copy mode)"
    echo -e "  ${GREEN}y${NC}                  Copy and exit (in copy mode)"
    echo -e "  ${GREEN}Ctrl+a p${NC}          Paste"
    
    pause_menu
}

show_vim() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ VIM COMMANDS ═══${NC}\n"
    
    echo -e "${CYAN}Leader Key (Space):${NC}"
    echo -e "  ${GREEN}Space w${NC}           Save file"
    echo -e "  ${GREEN}Space q${NC}           Quit"
    echo -e "  ${GREEN}Space wq${NC}          Save and quit"
    echo -e "  ${GREEN}Space d${NC}           Show error details"
    echo -e "  ${GREEN}Space j${NC}           Format JSON"
    echo -e "  ${GREEN}Space cc${NC}          Comment line/block"
    echo -e "  ${GREEN}Space cu${NC}          Uncomment"
    
    echo -e "\n${CYAN}Navigation:${NC}"
    echo -e "  ${GREEN}Ctrl+n${NC}            Toggle NERDTree"
    echo -e "  ${GREEN}Ctrl+p${NC}            Fuzzy file finder"
    echo -e "  ${GREEN}Ctrl+j/k${NC}          Move between splits"
    
    echo -e "\n${CYAN}Editing Power:${NC}"
    echo -e "  ${GREEN}*${NC}                  Search word under cursor"
    echo -e "  ${GREEN}ciw${NC}                Change inner word"
    echo -e "  ${GREEN}.${NC}                  Repeat last change"
    echo -e "  ${GREEN}:Format${NC}            Auto-format code"
    
    echo -e "\n${CYAN}Registers:${NC}"
    echo -e "  ${GREEN}:reg${NC}               Show all registers"
    echo -e "  ${GREEN}\"+y${NC}               Copy to system clipboard"
    echo -e "  ${GREEN}\"+p${NC}               Paste from system clipboard"
    
    pause_menu
}

show_git() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ GIT WORKFLOW ═══${NC}\n"
    
    echo -e "${CYAN}Interactive Functions:${NC}"
    echo -e "  ${GREEN}gia${NC}                Interactive git add with preview"
    echo -e "  ${GREEN}gco${NC}                Interactive branch checkout"
    echo -e "  ${GREEN}glo${NC}                Interactive git log viewer"
    
    echo -e "\n${CYAN}Basic Aliases:${NC}"
    echo -e "  ${GREEN}gs${NC}                 git status               Quick status"
    echo -e "  ${GREEN}gd${NC}                 git diff                 See changes"
    echo -e "  ${GREEN}gp${NC}                 git push                 Push commits"
    echo -e "  ${GREEN}gl${NC}                 git pull                 Pull changes"
    echo -e "  ${GREEN}gc${NC}                 git commit               Commit"
    
    echo -e "\n${CYAN}Power Commands:${NC}"
    echo -e "  ${GREEN}gundo${NC}              Undo last commit (keep changes)"
    echo -e "  ${GREEN}gwip${NC}               Quick WIP commit"
    echo -e "  ${GREEN}gclean${NC}             Delete merged branches"
    
    echo -e "\n${MAGENTA}Workflow Example:${NC}"
    echo -e "  ${BLUE}gs${NC}           # Check status"
    echo -e "  ${BLUE}gd${NC}           # Review changes"
    echo -e "  ${BLUE}gia${NC}          # Interactive add (multi-select)"
    echo -e "  ${BLUE}gc -m \"msg\"${NC}  # Commit with message"
    echo -e "  ${BLUE}gp${NC}           # Push"
    
    pause_menu
}

show_files() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ FILE OPERATIONS ═══${NC}\n"
    
    echo -e "${CYAN}Modern Replacements:${NC}"
    echo -e "  ${GREEN}ls${NC}        (eza)              Icons + Git status"
    echo -e "  ${GREEN}ll${NC}        (eza -l)           Detailed view"
    echo -e "  ${GREEN}tree${NC}      (eza --tree)       Directory tree"
    echo -e "  ${GREEN}cat${NC}       (bat)              Syntax highlighting"
    echo -e "  ${GREEN}cd${NC}        (zoxide)           Smart navigation"
    
    echo -e "\n${CYAN}Interactive Functions:${NC}"
    echo -e "  ${GREEN}vf${NC}                 Find and edit file"
    echo -e "  ${GREEN}cf${NC}                 Find and view file"
    echo -e "  ${GREEN}fgr${NC}                Find in files and edit"
    echo -e "  ${GREEN}fer${NC}                Find recent files (last 24h)"
    echo -e "  ${GREEN}del${NC}                Interactive file deletion"
    
    echo -e "\n${CYAN}Disk Usage:${NC}"
    echo -e "  ${GREEN}bigdirs${NC}            Show directories >10MB"
    echo -e "  ${GREEN}bigfiles${NC}           Show files >10MB"
    echo -e "  ${GREEN}bigstuff${NC}           Show both (comprehensive)"
    echo -e "  ${GREEN}duh${NC}                Disk usage of current dir"
    echo -e "  ${GREEN}du10${NC}               Top 10 largest items"
    
    pause_menu
}

show_system() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ SYSTEM MONITORING ═══${NC}\n"
    
    echo -e "${CYAN}Modern Tools:${NC}"
    echo -e "  ${GREEN}dust or dysk${NC}      (replaces du)      Visual disk usage"
    echo -e "  ${GREEN}duf or dysk${NC}       (replaces df)      Disk free info"
    
    echo -e "\n${CYAN}System Info:${NC}"
    echo -e "  ${GREEN}meminfo${NC}            Memory information"
    echo -e "  ${GREEN}cpuinfo${NC}            CPU information"
    echo -e "  ${GREEN}diskinfo${NC}           Disk usage (clean)"
    echo -e "  ${GREEN}ports${NC}              Show all open ports"
    
    echo -e "\n${CYAN}Process Management:${NC}"
    echo -e "  ${GREEN}pfind${NC}              Interactive process finder"
    echo -e "  ${GREEN}fkill${NC}              Fuzzy search and kill"
    echo -e "  ${GREEN}port <num>${NC}         Check what's using port"
    
    pause_menu
}

show_docker() {
    show_header
    echo -e "${YELLOW}${BOLD}═══ DOCKER UTILITIES ═══${NC}\n"
    
    echo -e "${CYAN}Docker Aliases:${NC}"
    echo -e "  ${GREEN}dps${NC}                Clean docker ps output"
    echo -e "  ${GREEN}dstop${NC}              Stop all containers"
    echo -e "  ${GREEN}dclean${NC}             Clean everything (prune)"
    
    echo -e "\n${MAGENTA}Examples:${NC}"
    echo -e "  ${BLUE}dps${NC}                 # View running containers"
    echo -e "  ${BLUE}dstop${NC}               # Stop all containers"
    echo -e "  ${BLUE}dclean${NC}              # Free up disk space"
    
    pause_menu
}
     
    search_all() {
        show_header
        echo -e "${YELLOW}${BOLD}═══ SEARCH ALL COMMANDS ═══${NC}\n"
        
        # Create searchable command list
        local commands=(
            "cdwn:curl resumable:Resumable download with auto-filename"
            "cgetjson:api get json:GET JSON with pretty print"
            "cpost:api post:POST JSON data"
            "cput:api put:PUT JSON data"
            "cdel:api delete:DELETE request"
            "jval:json extract:Extract single JSON value"
            "jfield:json array:Extract field from JSON array"
            "jfind:json filter:Filter JSON by condition"
            "extract:unzip tar:Universal archive extractor"
            "gitignore:git ignore:Generate .gitignore file"
            "backup:copy save:Create timestamped backup"
            "serve:http server:Start HTTP server"
            "pfind:process kill:Interactive process finder"
            "t:tmux session:Create/attach tmux session"
            "gia:git add:Interactive git add"
            "gco:git checkout:Interactive branch checkout"
            "glo:git log:Interactive git log"
            "vf:find file:Find and edit file"
            "ll:list files:Detailed file listing"
            "port:check port:Check what's using port"
            # Add these to the commands=() array in search_all() function:

# TMUX commands (missing from list)
"Ctrl+a z:tmux zoom:Zoom/fullscreen current pane"
"Ctrl+a [:tmux copy:Enter copy mode to scroll/copy"
"Ctrl+a r:tmux reload:Reload tmux configuration"
"Ctrl+a %:tmux vsplit:Vertical split pane"
"Ctrl+a \":tmux hsplit:Horizontal split pane"

# VIM commands (missing)
"Space w:vim save:Save file in vim"
"Space cc:vim comment:Comment line or block"
"Ctrl+n:vim tree:Toggle NERDTree file explorer"
":Format:vim format:Auto-format code with ALE"

# File operations (from your zshrc)
"vf:find edit:Find and edit file with fzf"
"cf:find view:Find and view file with fzf"
"fgr:find grep:Find in files and open in editor"
"fer:find recent:Find and edit recent files (24h)"
"mkcd:make cd:Create directory and cd into it"
"del:delete interactive:Interactive file deletion"
"cat_exts:cat extension:Cat all files by extension"

# System monitoring (from your zshrc)
"bigdirs:disk dirs:Show large directories >10MB"
"bigfiles:disk files:Show large files >10MB"
"bigstuff:disk all:Show large dirs and files"
"duh:disk usage:Disk usage of current directory"
"du10:disk top10:Top 10 largest items"
"meminfo:memory info:Memory information"
"cpuinfo:cpu info:CPU information"
"diskinfo:disk info:Clean disk usage info"

# Git workflow (from your zshrc)
"gundo:git undo:Undo last commit (keep changes)"
"gwip:git wip:Quick WIP commit"
"gclean:git clean:Delete merged branches"
"gs:git status:Git status"
"gd:git diff:Git diff"

# Utilities (from your zshrc)
"weather:weather forecast:Get weather forecast"
"myip:public ip:Get your public IP address"
"cpy:clipboard copy:Copy file or pipe to clipboard"
"todo:find todos:Find TODO/FIXME in code"
"dark_mode:theme dark:Switch to dark theme"

# Modern CLI (from your zshrc)
"ll:list long:Detailed file listing with icons"
"tree:directory tree:Directory tree view"
"r:ranger:Launch ranger file manager"

# Task management (from your zshrc)
"tda:todo add:Add new task"
"tdl:todo list:List all tasks"
"tdd:todo done:Mark task as done"

# Aliases (from your zshrc)
"...:up3:Go up 3 directories"
"~:home:Go to home directory"
"h:history:Show command history"
"c:clear:Clear terminal screen"
"cpv:copy progress:Copy with progress bar"
"ports:open ports:Show all open ports"

# Development (from your zshrc)
"npmls:npm list:List installed npm packages"
"pipls:pip list:List installed pip packages"
"venv:python venv:Create and activate venv"

# Docker (from your zshrc)
"dstop:docker stop:Stop all containers"
"dclean:docker clean:Clean docker system"

# Session management (from your tmux.conf)
"t:tmux session:Create/attach tmux session"
"tt:tmux switch:Tmux session switcher with fzf"
	    "btop:system monitor:System dashboard"
            "dps:docker ps:Docker container list"
        )
        
        echo -e "${CYAN}Type to search (press Ctrl+C to exit):${NC}\n"
        
        # Use fzf if available, otherwise simple grep
        if command -v fzf &>/dev/null; then
            printf '%s\n' "${commands[@]}" | \
                fzf --height 50% --reverse \
                    --header="Search commands (type to filter)" \
                    --preview 'echo {}' \
                    --preview-window=up:3:wrap | \
                awk -F: '{printf "\033[1;32m%-15s\033[0m %s\n", $1, $3}'
        else
            echo -n "Search term: "
            read search_term
            printf '%s\n' "${commands[@]}" | \
                grep -i "$search_term" | \
                awk -F: '{printf "\033[1;32m%-15s\033[0m %s\n", $1, $3}'
        fi
        
        echo ""
        pause_menu
    }
    
    pause_menu() {
        echo ""
        echo -n "Press Enter to return to menu (or 'q' to quit): "
        read input
        if [[ "$input" == "q" ]]; then
            return
        fi
        show_menu
    }
    
    # Main entry point
    case "$category" in
        menu|m) show_menu ;;
        curl|api|c) show_curl ;;
        jq|json|j) show_jq ;;
        essential|e|fun) show_essential ;;
        tmux|t) show_tmux ;;
        vim|v) show_vim ;;
        git|g) show_git ;;
        file|files|f) show_files ;;
        system|sys|s) show_system ;;
        docker|d) show_docker ;;
        search|all|a) search_all ;;
        *)
            echo "Usage: cheat [category]"
            echo ""
            echo "Categories:"
            echo "  curl, jq, essential, tmux, vim, git, files, system, docker, search"
            echo ""
            echo "Or just run 'cheat' for interactive menu"
            ;;
    esac
}

# Shorter alias
alias ch='cheat'

# Quick help for specific command
chelp() {
    if [ -z "$1" ]; then
        echo "Usage: chelp <command>"
        echo "Example: chelp cgetjson"
        return 1
    fi
    
    case "$1" in
        cgetjson)
            echo "cgetjson - GET JSON with pretty print"
            echo "Usage: cgetjson <URL>"
            echo "Example: cgetjson https://api.github.com/users/yomazini"
            ;;
        cpost)
            echo "cpost - POST JSON data"
            echo "Usage: cpost <URL> <DATA_OR_FILE>"
            echo "Examples:"
            echo "  cpost https://api.test.com/users '{\"name\":\"John\"}'"
            echo "  cpost https://api.test.com/users @user.json"
            ;;
        jfind)
            echo "jfind - Filter JSON by condition"
            echo "Usage: ... | jfind <KEY> <VALUE> [--contains|-c]"
            echo "Examples:"
            echo "  cgetjson <url> | jfind language \"C\""
            echo "  cgetjson <url> | jfind body \"error\" -c  # partial match"
            ;;
        extract)
            echo "extract - Universal archive extractor"
            echo "Usage: extract <archive>"
            echo "Supports: .tar.gz, .zip, .rar, .7z, .bz2, etc."
            echo "Example: extract project.tar.gz"
            ;;
        *)
            echo "No specific help for '$1'"
            echo "Try: cheat search"
            ;;
    esac
}
# sudo apt install git-delta
alias difff='delta --side-by-side' 




# Function to initialize VS Code C++ development environment.
# Creates .vscode configs and .clang-format only.
cpp-init() {
    echo "Initializing VS Code C++ environment in current directory: $(pwd)"

    # --- 1. Generate .clang-format ---
    cat << 'EOF' > .clang-format
# --- Professional C++ Formatting Style (RECOMMENDED: Space-Based Indentation) ---
BasedOnStyle: Google

# --- Indentation ---
# Use 4 SPACES for indentation. This is the most common and consistent standard.
UseTab: Never
IndentWidth: 4

# --- Braces and Code Structure ---
# Use Allman-style braces (braces on new lines). Hugely improves readability.
# void func()
# {
#     ...
# }
BreakBeforeBraces: Allman
AllowShortBlocksOnASingleLine: false
AllowShortFunctionsOnASingleLine: None

# --- Function Calls and Parameters ---
# Prevents clang-format from cramming long lists of parameters onto one line.
# Forces a clean, one-parameter-per-line layout for long function signatures.
BinPackParameters: false
BinPackArguments: false

# --- Pointer and Reference Alignment ---
# Align pointer/reference symbols to the type (e.g., int* p).
# Reinforces that the type is "pointer-to-int".
PointerAlignment: Right

# --- Include Directives ---
# Automatically sorts includes and groups them by category.
SortIncludes: true
IncludeBlocks: Regroup
IncludeCategories:
  - Regex: '^<.*\.h>'
    Priority: 1  # C-style standard library headers
  - Regex: '^<.*>'
    Priority: 2  # C++ standard library headers
  - Regex: '.*'
    Priority: 3  # Project-local headers ("MyClass.hpp")

# --- General Style & Whitespace ---
ColumnLimit: 80
SpaceBeforeParens: ControlStatements
SpaceAfterCStyleCast: true
EOF
    echo "✓ Generated .clang-format"

    # --- 2. Generate VS Code Configuration ---
    mkdir -p .vscode

    # c_cpp_properties.json
    cat << 'EOF' > .vscode/c_cpp_properties.json
{
  "configurations": [
    {
      "name": "linux-gcc-x64",
      "includePath": [
        "${workspaceFolder}/**"
      ],
      "compilerPath": "/usr/bin/gcc",
      "cStandard": "${default}",
      "cppStandard": "${default}",
      "intelliSenseMode": "linux-gcc-x64",
      "compilerArgs": [
        ""
      ]
    }
  ],
  "version": 4
}
EOF

    # gdb-wrapper.sh
    cat << 'EOF' > .vscode/gdb-wrapper.sh
#!/bin/sh
exec flatpak-spawn --host gdb "$@"
EOF
    chmod +x .vscode/gdb-wrapper.sh

    # launch.json
    cat << 'EOF' > .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(gdb) Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}/${fileBasenameNoExtension}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "preLaunchTask": "C++ build"
        }
    ]
}
EOF

    # settings.json
    cat << 'EOF' > .vscode/settings.json
{
  "files.associations": {
    "ostream": "cpp",
    "array": "cpp",
    "atomic": "cpp",
    "bit": "cpp",
    "cctype": "cpp",
    "charconv": "cpp",
    "chrono": "cpp",
    "clocale": "cpp",
    "cmath": "cpp",
    "compare": "cpp",
    "concepts": "cpp",
    "cstdarg": "cpp",
    "cstddef": "cpp",
    "cstdint": "cpp",
    "cstdio": "cpp",
    "cstdlib": "cpp",
    "cstring": "cpp",
    "ctime": "cpp",
    "cwchar": "cpp",
    "cwctype": "cpp",
    "deque": "cpp",
    "map": "cpp",
    "string": "cpp",
    "unordered_map": "cpp",
    "vector": "cpp",
    "exception": "cpp",
    "algorithm": "cpp",
    "functional": "cpp",
    "iterator": "cpp",
    "memory": "cpp",
    "memory_resource": "cpp",
    "numeric": "cpp",
    "optional": "cpp",
    "random": "cpp",
    "ratio": "cpp",
    "string_view": "cpp",
    "system_error": "cpp",
    "tuple": "cpp",
    "type_traits": "cpp",
    "utility": "cpp",
    "format": "cpp",
    "initializer_list": "cpp",
    "iomanip": "cpp",
    "iosfwd": "cpp",
    "iostream": "cpp",
    "istream": "cpp",
    "limits": "cpp",
    "new": "cpp",
    "numbers": "cpp",
    "span": "cpp",
    "sstream": "cpp",
    "stdexcept": "cpp",
    "streambuf": "cpp",
    "text_encoding": "cpp",
    "cinttypes": "cpp",
    "typeinfo": "cpp",
    "variant": "cpp"
  },
  "C_Cpp_Runner.cCompilerPath": "gcc",
  "C_Cpp_Runner.cppCompilerPath": "g++",
  "C_Cpp_Runner.debuggerPath": "gdb",
  "C_Cpp_Runner.cStandard": "",
  "C_Cpp_Runner.cppStandard": "",
  "C_Cpp_Runner.msvcBatchPath": "",
  "C_Cpp_Runner.useMsvc": false,
  "C_Cpp_Runner.warnings": [
    "-Wall",
    "-Wextra",
    "-Wpedantic",
    "-Wshadow",
    "-Wformat=2",
    "-Wcast-align",
    "-Wconversion",
    "-Wsign-conversion",
    "-Wnull-dereference"
  ],
  "C_Cpp_Runner.msvcWarnings": [
    "/W4",
    "/permissive-",
    "/w14242",
    "/w14287",
    "/w14296",
    "/w14311",
    "/w14826",
    "/w44062",
    "/w44242",
    "/w14905",
    "/w14906",
    "/w14263",
    "/w44265",
    "/w14928"
  ],
  "C_Cpp_Runner.enableWarnings": true,
  "C_Cpp_Runner.warningsAsError": false,
  "C_Cpp_Runner.compilerArgs": [],
  "C_Cpp_Runner.linkerArgs": [],
  "C_Cpp_Runner.includePaths": [],
  "C_Cpp_Runner.includeSearch": [
    "*",
    "**/*"
  ],
  "C_Cpp_Runner.excludeSearch": [
    "**/build",
    "**/build/**",
    "**/.*",
    "**/.*/**",
    "**/.vscode",
    "**/.vscode/**"
  ],
  "C_Cpp_Runner.useAddressSanitizer": false,
  "C_Cpp_Runner.useUndefinedSanitizer": false,
  "C_Cpp_Runner.useLeakSanitizer": false,
  "C_Cpp_Runner.showCompilationTime": false,
  "C_Cpp_Runner.useLinkTimeOptimization": false,
  "C_Cpp_Runner.msvcSecureNoWarnings": false
}
EOF

    # tasks.json
    cat << 'EOF' > .vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "C++ build",
            "type": "shell",
            "command": "g++",
            "args": ["-g", "-std=c++17", "${file}", "-o", "${fileDirname}/${fileBasenameNoExtension}"],
            "group": {"kind": "build", "isDefault": true},
            "problemMatcher": ["$gcc"]
        }
    ]
}
EOF

    echo "✓ Generated VS Code configurations in .vscode/"
    echo ""
    echo "Created files:"
    echo "  - .clang-format"
    echo "  - .vscode/c_cpp_properties.json"
    echo "  - .vscode/gdb-wrapper.sh"
    echo "  - .vscode/launch.json"
    echo "  - .vscode/settings.json"
    echo "  - .vscode/tasks.json"
    echo ""
    echo "✓ Initialization complete!"
}

# Alias for quick access
alias cppi='cpp-init'





# ===================


# --- FIX FOR KEYBOARD INPUT ISSUES ON WAYLAND; Simple Fix---
#
# If you experience problems with keyboard input (e.g., arrow keys,
# the Super key, or other shortcuts not working) in some applications,
# it might be an issue with IBus (Intelligent Input Bus) or apps not
# running in native Wayland mode.
#
# Uncomment the following lines to force all applications to use IBus and
# run in native Wayland, then source zshrcc
#
# export GTK_IM_MODULE=ibus
# export QT_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_QPA_PLATFORM=wayland

# export GDK_BACKEND=wayland
# ibus restart 


# -- Final Powerlevel10k Sourcing (MUST be at the end) --
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
