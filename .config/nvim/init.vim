set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
lua << EOF
local cmd = {
    "julia",
    "--startup-file=no",
    "--history-file=no",
    vim.fn.expand("~/.config/nvim/lsp-julia/run.jl")
}
require'lspconfig'.julials.setup{
    cmd = cmd,
    -- Why do I need this? Shouldn't it be enough to override cmd on the line above?
    on_new_config = function(new_config, _)
        new_config.cmd = cmd
    end,
    filetypes = {"julia"},
}
-- vim.lsp.set_log_level("debug")
EOF
