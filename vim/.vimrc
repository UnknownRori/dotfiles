call plug#begin()
" below are some vim plugins for demonstration purpose.
" add the plugin you want to use here.
Plug 'drewtempelmeyer/palenight.vim'
Plug 'vim-airline/vim-airline'
Plug 'wlangstroth/vim-racket'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/tagbar'
Plug 'StanAngeloff/php.vim'
Plug 'universal-ctags/ctags'
Plug 'luochen1990/rainbow'
Plug 'vim-syntastic/syntastic'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tommcdo/vim-lion'
Plug 'Shirk/vim-gas'
Plug 'ntpeters/vim-better-whitespace'
call plug#end()

" Syntax highlighting
syntax on

" Position in code
set number
set relativenumber

set nowrap

set tabstop=4
set smartindent
set shiftwidth=4
set expandtab
set ruler

" Don't make noise
set visualbell

" default file encoding
set encoding=utf-8

set mouse=a

set colorColumn=80
highlight colorColumn ctermbg=0 guibg=lightgrey

inoremap jj <c-[>
cnoremap <expr> j
      \ getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'

inoremap j<Space>     j  "insert j immediately
cnoremap j<Space>     j  "insert j immediately

tnoremap   jj         <C-\><C-n>

nnoremap <Space>w     :w<CR>
nnoremap <Space>q     :q<CR>