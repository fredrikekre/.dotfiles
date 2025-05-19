-- Leader have to be set before any plugins are loaded
vim.g.mapleader = " "

-- Various mappings
vim.keymap.set("i", "jk", "<Esc>")

-- Enable termguicolors
vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Store undo history
vim.opt.undofile = true

-- Use OS clipboard for yank/paste
vim.opt.clipboard = "unnamedplus"

-- Tab and indent settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true

-- Highlight without moving
vim.keymap.set("n", "*", "*``")

-- More natural split directions
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Auto-resize splits when terminal window changes size
-- (e.g. when splitting or zooming with tmux)
vim.api.nvim_create_autocmd( {"VimResized"}, {pattern = "*", command = "wincmd ="})

-- Keep some lines above/below cursor
vim.opt.scrolloff = 10

-- Disable mouse (default on since neovim 0.8)
vim.opt.mouse = ""

-- Show trailing whitespace etc
vim.opt.list = true
vim.opt.listchars = {tab = ">-", trail = "-", nbsp = "+"}

-- Autocommands
local augroup_julia = vim.api.nvim_create_augroup("FileTypeJulia", {})
vim.api.nvim_create_autocmd(
    {"FileType"},
    {
        group = augroup_julia,
        pattern = "julia",
        callback = function(ev)
            vim.opt_local.textwidth = 92
            vim.opt_local.colorcolumn = "93"
        end,
    }
)

-- Show diagnostics as virtual text (disabled by default since 0.11)
vim.diagnostic.config({ virtual_text = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy and configure plugins
require("lazy").setup({
    spec = {import = "plugins"},
    install = {colorscheme = {"catppuccin-mocha"}},
    change_detection = {notify = false},
})
