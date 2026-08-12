-- https://github.com/nvim-treesitter/nvim-treesitter
-- Note that this requires the tree-sitter CLI on PATH
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        ts.setup({})
        -- Install parsers async
        ts.install({"julia", "markdown", "markdown_inline", "lua"})
        -- Enable tree-sitter based highlighting
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}
