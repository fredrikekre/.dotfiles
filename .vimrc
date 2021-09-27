call plug#begin('~/.vim/plugged')

    "Julia support
    Plug 'JuliaEditorSupport/julia-vim'
    "TOML syntax highlighting
    Plug 'cespare/vim-toml'
    "LaTeX
    Plug 'lervag/vimtex'

    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    Plug 'morhetz/gruvbox'

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'tpope/vim-commentary'

    if has('nvim')
        Plug 'neovim/nvim-lspconfig'
    end

call plug#end()

"Need to specify latex flavor for the lervag/vimtex plugin
:let g:tex_flavor = 'latex'
"Color scheme
:let g:gruvbox_contrast_dark='hard'
:colorscheme gruvbox
:highlight Normal ctermbg=NONE
"Line numbers
:set number
"Column guide
:set colorcolumn=93
"Misc keymappings and configurations
:imap jk <Esc> |"use jk for exiting insert mode
:set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent "Nicer tab actions
"Move aroung splits without the C-W prefix
:nnoremap <C-J> <C-W><C-J>
:nnoremap <C-K> <C-W><C-K>
:nnoremap <C-L> <C-W><C-L>
:nnoremap <C-H> <C-W><C-H>
"Easier fzf keybindings
:nnoremap <C-F> :Rg!<CR>
:nnoremap <C-O> :Files!<CR>
"More natural split directions
:set splitbelow
:set splitright
"Auto-resize splits when terminal window changes size (e.g. when splitting or
"zooming with tmux
:autocmd VimResized * wincmd =
"Airline status bar
:let g:airline_theme='bubblegum'
"Keep some lines above/below cursor
:set scrolloff=10

"Use clipboard for everything (instead of */+ registers)
:set clipboard+=unnamedplus
