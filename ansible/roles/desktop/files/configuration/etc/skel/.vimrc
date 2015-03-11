set nocompatible
filetype off
let g:phpcomplete_parse_docblok_comments = 1

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"plugin manager
Plugin 'gmarik/Vundle.vim'
"rst plugin
Plugin 'Rykka/riv.vim'
"rst instant preview
Plugin 'Rykka/InstantRst'
"better completion for php
Plugin 'shawncplus/phpcomplete.vim'
"rainbow parenthesis
Plugin 'amdt/vim-niji'
"file browser
Plugin 'scrooloose/nerdtree'
"fuzzy search
Plugin 'kien/ctrlp.vim'
"highlights modified/new lines
Plugin 'airblade/vim-gitgutter'
"git wrapper
Plugin 'tpope/vim-fugitive'
"comments
Plugin 'scrooloose/nerdcommenter'

call vundle#end()

filetype plugin indent on

highlight clear SignColumn

"gvim
set guioptions-=m

set number
set wildmenu
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set laststatus=2
set backspace=indent,eol,start
set history=100
set mouse=a
set noswapfile

syntax on

