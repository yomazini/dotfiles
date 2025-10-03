"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🚀 Ultimate Developer Dotfiles Zshrc 🚀         ║
║                                                                  ║
║   Transform your terminal into a modern development environment  ║
║                                                                  ║
║   Author: Youssef Mazini (ymazini)                              ║
║   GitHub: https://github.com/yomazini/dotfiles                  ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
"

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
