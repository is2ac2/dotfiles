" vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" required vundle
call vundle#end()
filetype plugin indent on

set runtimepath+=~/.vim_runtime

" base vimrc
source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

