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

# -- The main command will be 'todo'

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
