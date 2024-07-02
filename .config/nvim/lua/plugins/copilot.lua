-- https://github.com/github/copilot.vim

return {
    "github/copilot.vim",
    config = function()
        vim.g.copilot_filetypes = {
            ["*"] = false,
            julia = true,
            markdown = true,
        }
    end,
}
