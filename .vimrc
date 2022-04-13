call plug#begin('~/.vim/plugged')

    "Julia support
    Plug 'JuliaEditorSupport/julia-vim'

    "fzf plugins
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " Gruvbox color theme
    "Plug 'morhetz/gruvbox'
    Plug 'fredrikekre/gruvbox'

    "Status/tabline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    "Comment/out blocks of code
    Plug 'tpope/vim-commentary'

    "Git plugin
    Plug 'tpope/vim-fugitive'

    if has('nvim')
        " LSP helpers
        Plug 'neovim/nvim-lspconfig'
        " nvim-cmp and completion sources
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        " Plug 'hrsh7th/cmp-cmdline'
        Plug 'hrsh7th/nvim-cmp'
        " Snippet engine required for nvim-cmp (expands things from LS)
        Plug 'L3MON4D3/LuaSnip'
        Plug 'saadparwaiz1/cmp_luasnip'
    end

call plug#end()

" Color scheme
:let g:gruvbox_contrast_dark='harder'
:let g:gruvbox_invert_selection=0
:let g:gruvbox_sign_column='bg0'
:colorscheme gruvbox
:set termguicolors

"Line numbers
:set number relativenumber

" Column guide
:set colorcolumn=93
:highlight ColorColumn guibg='#1d2021'

" Show trailing whitespace etc
:set list listchars=tab:>-,trail:-,nbsp:+

"Misc keymappings and configurations
:imap jk <Esc>
:let mapleader = " "
:set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent "Nicer tab actions
"Move aroung splits without the C-W prefix
:nnoremap <C-J> <C-W><C-J>
:nnoremap <C-K> <C-W><C-K>
:nnoremap <C-L> <C-W><C-L>
:nnoremap <C-H> <C-W><C-H>
"Easier fzf keybindings
:nnoremap <C-F> :Rg!<CR>
:nnoremap <C-P> :GFiles!<CR>
"More natural split directions
:set splitbelow
:set splitright
"Auto-resize splits when terminal window changes size (e.g. when splitting or
"zooming with tmux
:autocmd VimResized * wincmd =

" Airline status bar
:let g:airline_theme='bubblegum'
":let g:airline_left_sep=''
":let g:airline_right_sep=''
:let g:airline#extensions#tabline#enabled = 1
":let g:airline#extensions#tabline#left_sep=''
:let g:airline_skip_empty_sections = 1
:set noshowmode " Already showed by airline

"Keep some lines above/below cursor
:set scrolloff=10

"Use clipboard for everything (instead of */+ registers)
:set clipboard+=unnamedplus
