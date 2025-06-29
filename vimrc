
"╔══════════════════════════════════════════════════════════════════╗
"║                                                                  ║
"║   🚀 Ultimate Developer Dotfiles Vimrc 🚀         ║
"║                                                                  ║
"║   Transform your terminal into a modern development environment  ║
"║                                                                  ║
"║   Author: Youssef Mazini (ymazini)                              ║
"║   GitHub: https://github.com/yomazini/dotfiles                  ║
"║                                                                  ║
"╚══════════════════════════════════════════════════════════════════╝

" ===================================================================
" === A Modern Vim IDE Configuration (Corrected Version) ============
" ===================================================================

" --- Section 1: Plugin Management (vim-plug) ---
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim' " <== THIS LINE IS NOW CORRECTED
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdcommenter'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

call plug#end()


" ===================================================================
" === Section 2: Basic Editor Settings ==============================
" ===================================================================
syntax on
set number
set relativenumber
set cursorline
set mouse=a
set clipboard=unnamedplus
set ignorecase
set smartcase
set wrap!
set hidden

" --- Leader Key ---
let mapleader = " "


" ===================================================================
" === Section 3: Plugin Configurations ==============================
" ===================================================================

" --- Gruvbox Theme ---
set background=dark
colorscheme gruvbox

" --- NERDTree (File Explorer) ---
nnoremap <C-n> :NERDTreeToggle<CR>

" --- CtrlP (Fuzzy File Finder) ---
" This is the corrected syntax for ignoring multiple directory patterns.
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll)$'
    \ }
let g:ctrlp_user_command = 'fd --type f --hidden --exclude .git'



nnoremap <leader>j :%!jq .<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
" --- ALE (Syntax Checking) ---
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_save = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
nnoremap <leader>d :ALEDetail<CR>
let g:ale_completion_enabled = 1

" FIX FOR PROBLEM 6: Tell clangd where to find standard C headers
" let g:ale_c_clangd_options = '-I/usr/include'
"
" " FIX FOR PROBLEM 5: Define the language servers for ALE to use
 let g:ale_linters = {
 \   'c': ['clangd'],
 \   'cpp': ['clangd'],
 \   'javascript': ['tsserver'],
 \   'python': ['pylsp'],
 \   'sh': ['bash-language-server'],
 \}

" FIX FOR PROBLEM 7: Define the code formatters for ALE to use
 let g:ale_fixers = {
 \   '*': ['remove_trailing_lines', 'trim_whitespace'],
 \   'c': ['clang-format'],
 \   'cpp': ['clang-format'],
 \   'javascript': ['prettier'],
 \   'python': ['autopep8'], 
 \}
" --- Custom Commands ---
"  " Goal: Create new, simple commands for common multi-step tasks.
"
"  " Creates a :Format command that uses ALE to auto-format your code.
  command! Format :ALEFix<CR>
nnoremap <leader>d :ALEDetail<CR>

"  " Creates a :GStatus command that opens a vertical split with the git
"  status.
  command! GStatus vnew | term git status

" Add this line to create the JSON formatting shortcut"" 
"nnoremap <leader>j :%!jq .<CR> 
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
command! Format :ALEFix
