" required
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" required
call vundle#end()
filetype plugin indent on

" color scheme
Bundle 'desert-warm-256'
colorscheme desert-warm-256

" turns of syntax highlighting
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

