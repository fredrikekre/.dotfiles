-- https://github.com/mfussenegger/nvim-lint
return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        -- Configure linters by filetype
        lint.linters_by_ft = {
            sh = {"shellcheck"},
        }
        -- Configure auto commands to trigger linting when opening and writing to disk
        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = "sh",
            once = true,
            callback = function()
                -- Trigger lint whenever writing to disk
                vim.api.nvim_create_autocmd({"BufWritePost"}, {
                    callback = function()
                        lint.try_lint("shellcheck")
                    end,
                })
                -- Trigger linting now
                lint.try_lint("shellcheck")
            end,
        })
    end,
}
