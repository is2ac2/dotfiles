" required
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" syntax highlighting
" Plugin 'vim-syntastic/syntastic'
" Plugin 'integralist/vim-mypy'

" indentation
Plugin 'vim-scripts/indentpython.vim'

" code search
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" text alignment
Plugin 'junegunn/vim-easy-align'

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
" nnoremap <buffer> <localleader>mp :call mypy#ExecuteMyPy()<cr>
" let python_highlight_all=1
" let g:flake8_show_quickfix=1

" show file name in status bar
set statusline+=%F

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" tab movement
nnoremap  th  :tabfirst<CR>
nnoremap  tk  :tabnext<CR>
nnoremap  tj  :tabprev<CR>
nnoremap  tl  :tablast<CR>
nnoremap  tt  :tabedit<Space>
nnoremap  tn  :tabnext<Space>
nnoremap  tm  :tabm<Space>
nnoremap  td  :tabclose<CR>

" tab movement with <Ctrl + Space> and <Ctrl + t>
nnoremap  <C-S-@>  :tabprevious<CR>
nnoremap  <C-@>    :tabnext<CR>
nnoremap  <C-t>    :tabnew<CR>
inoremap  <C-S-@>  <Esc>:tabprevious<CR>i
inoremap  <C-@>    <Esc>:tabnext<CR>i
inoremap  <C-t>    <Esc>:tabnew<CR>

" tab highlighting
highlight TabLineFill ctermfg=Black ctermbg=White
highlight TabLine     ctermfg=White ctermbg=Black
highlight TabLineSel  ctermfg=Black ctermbg=White
highlight Title       ctermfg=Black ctermbg=White

" aliases for common typos
noreabbrev W w
noreabbrev Q q
noreabbrev X x
noremap    ; :
noremap    ; :

" expand %% to current file path
cabbr <expr> %% expand('%:p:h')

" code search
nnoremap <silent> <C-f> :Files<CR>

" text alignment
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" scrollbar
set mouse=a
set ttymouse=xterm2

" remove whitespace on write
autocmd FileType c,cpp,java,php,cu,py autocmd BufWritePre <buffer> %s/\s\+$//e

" underscores as word boundaries
set iskeyword-=_

