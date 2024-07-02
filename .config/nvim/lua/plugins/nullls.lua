-- https://github.com/jose-elias-alvarez/null-ls.nvim
return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
        {"nvim-lua/plenary.nvim"},
    },
    config = function()
        local null_ls = require("null-ls")
        local opts = {
            sources = {
                null_ls.builtins.diagnostics.shellcheck,
            },
        }
        null_ls.setup(opts)
    end,
}
