" required
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" syntax highlighting
Plugin 'vim-syntastic/syntastic'
Plugin 'integralist/vim-mypy'

" indentation
Plugin 'vim-scripts/indentpython.vim'

" code search
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" required
call vundle#end()
filetype plugin indent on

" color scheme
Bundle 'desert-warm-256'
colorscheme desert-warm-256

" turns on syntax highlighting
syntax enable

" use spaces not tabs
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" show line numbers
set relativenumber

" show command in bottom bar
set showcmd

" highlight current line
set cursorline

" load filetype-specific indent files
filetype indent on

" highlight matches
set showmatch

" search
set incsearch
set hlsearch

" turn of highlighting
nnoremap <leader><space> :nohlsearch<CR>

" remap for navigating windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" python indentation
au BufNewFile,BufRead *.py set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ expandtab
    \ autoindent
    \ fileformat=unix

" full-stack
au BufNewFile,BufRead *.js, *.html, *.css set
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

" utf--8
set encoding=utf-8

" mypy
nnoremap <buffer> <localleader>mp :call mypy#ExecuteMyPy()<cr>

let python_highlight_all=1
let g:flake8_show_quickfix=1

