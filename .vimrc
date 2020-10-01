call plug#begin('~/.vim/plugged')

    "Julia support
    Plug 'JuliaEditorSupport/julia-vim'
    "TOML syntax highlighting
    Plug 'cespare/vim-toml'
    "LaTeX
    Plug 'lervag/vimtex'

call plug#end()

"Need to specify latex flavor for the lervag/vimtex plugin
:let g:tex_flavor = 'latex'

"Enable colors and set color scheme
"if has('nvim')                                                                                                                                                                                                  
if exists('+termguicolors')
    :set termguicolors
endif
:colorscheme monokai-black

"Line numbers
:set number

"Misc keymappings and configurations
:imap jk <Esc> |"use jk for exiting insert mode
:set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent "Nicer tab actions

"Move aroung splits without the C-W prefix
:nnoremap <C-J> <C-W><C-J>
:nnoremap <C-K> <C-W><C-K>
:nnoremap <C-L> <C-W><C-L>
:nnoremap <C-H> <C-W><C-H>
"More natural split directions
:set splitbelow
:set splitright
"Auto-resize splits when terminal window changes size (e.g. when splitting or
"zooming with tmux
:autocmd VimResized * wincmd =

