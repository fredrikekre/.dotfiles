-- Plugins that don't require any advanced config
return {
    -- https://github.com/christoomey/vim-tmux-navigator
    {"christoomey/vim-tmux-navigator"},
    -- https://github.com/JuliaEditorSupport/julia-vim
    {"JuliaEditorSupport/julia-vim"},
    -- https://github.com/tpope/vim-commentary
    {"tpope/vim-commentary"},
    -- https://github.com/tpope/vim-fugitive
    {"tpope/vim-fugitive"},
    -- https://github.com/tpope/vim-rhubarb
    {"tpope/vim-rhubarb"},
    -- https://github.com/nvim-lua/plenary.nvim
    {"nvim-lua/plenary.nvim"},
    -- https://github.com/andythigpen/nvim-coverage
    {"andythigpen/nvim-coverage", opts = {lang = {julia = {directories = "src,ext,juliac"}}}},
}
