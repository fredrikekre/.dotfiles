call plug#begin('~/.vim/plugged')

    "Julia support
    Plug 'JuliaEditorSupport/julia-vim'

    "fzf plugins
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " Gruvbox color theme
    Plug 'gruvbox-community/gruvbox'

    "Status/tabline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    "Comment/out blocks of code
    Plug 'tpope/vim-commentary'

    "Git plugin
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'

    " Send code to REPL
    Plug 'jpalardy/vim-slime'

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

        " Git changes in the sign column
        Plug 'lewis6991/gitsigns.nvim'

        " Code coverage in sign column
        Plug 'nvim-lua/plenary.nvim'
        Plug 'andythigpen/nvim-coverage'

        " null-ls
        " Plug 'nvim-lua/plenary.nvim'
        Plug 'jose-elias-alvarez/null-ls.nvim'
    end

call plug#end()

" Color scheme adjustments
:let g:gruvbox_colors = {}
:let g:gruvbox_colors.dark0 = ['#0f0f0f', 233]
:let g:gruvbox_colors.dark1 = ['#282828', 235] " dark0
:let g:gruvbox_colors.dark2 = ['#3c3836', 237] " dark1
:let g:gruvbox_colors.dark3 = ['#504945', 239] " dark2
:let g:gruvbox_colors.dark4 = ['#665c54', 241] " dark3
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
"Highlight without moving
:nnoremap * *``
"Move aroung splits without the C-W prefix
:nnoremap <C-J> <C-W><C-J>
:nnoremap <C-K> <C-W><C-K>
:nnoremap <C-L> <C-W><C-L>
:nnoremap <C-H> <C-W><C-H>
"Easier fzf keybindings
:nnoremap <C-F> :Rg!<CR>
:nnoremap <expr> <C-P> (len(system('git rev-parse')) ? ':Files!' : ':GFiles!')."<CR>"
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

" vim-slime settings for use in tmux
:let g:slime_target="tmux"
:let g:slime_default_config={"socket_name": "default", "target_pane": "{last}"}
:let g:slime_dont_ask_default=1
:function SlimeOverrideConfig()
:    " This expands {last} to a fixed pane id. This is done in the override function in
:    " order to delay the expansion until first usage instead of when Vim starts.
:    let b:slime_config = g:slime_default_config
:    let l:last_pane_id = trim(system('tmux display -pt "{last}" "#{pane_id}"'))
:    let b:slime_config['target_pane'] = l:last_pane_id
:endfunction
:let g:slime_bracketed_paste=1
:nnoremap <C-c><C-c> <Plug>SlimeParagraphSend
:nnoremap <S-CR> <Plug>SlimeParagraphSend
:xnoremap <C-c><C-c> <Plug>SlimeRegionSend
:xnoremap <S-CR> <Plug>SlimeRegionSend
