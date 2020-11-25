"source $VIMRUNTIME/defaults.vim

" Plugins
call plug#begin('~/.vim/plugged')
" Themes
Plug 'morhetz/gruvbox'
"Plug 'rafi/awesome-vim-colorschemes'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
" Code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Misc
Plug 'jiangmiao/auto-pairs'
"Plug 'scrooloose/syntastic'
"Plug 'ycm-core/YouCompleteMe'
Plug 'RRethy/vim-hexokinase'
call plug#end()

" Basic settings
set ignorecase
set smartcase
set number
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
"set background=dark
set mouse=a
set termguicolors
"set clipboard+=unnamed
"colorscheme codedark
colorscheme nord
"colorscheme gruvbox

" Afterglow
"let g:afterglow_inherit_background=1

" Hexokinase
let g:Hexokinase_highlighters = ['backgroundfull']

" Vim-airline
"let g:airline#extensions#wordcount#enabled = 1
"let g:airline#extensions#hunks#non_zero_only = 1
"let g:airline_theme = 'codedark'

" The lightline.vim theme 
let g:lightline = {
    \ 'colorscheme': 'darcula',
    \ } 
" Always show statusline 
"set laststatus=2 
" Uncomment to prevent non-normal modes showing in powerline and below powerline. 
"set noshowmode
