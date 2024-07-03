-- https://github.com/lewis6991/gitsigns.nvim

local function configure_gitsigns()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
        signs = {
            add = {text = "+"},
            change = {text = "±"},
        },
        signs_staged_enable = false, -- TODO: Enable this with signs_staged configured
        on_attach = function(bufnr)
            local opts = {buffer = bufnr, silent = true}
            -- Hunk navigation
            for _, x in pairs({{key = "]c", dir = "next"}, {key = "[c", dir = "prev"}}) do
                vim.keymap.set(
                    "n", x.key,
                    function()
                        if vim.wo.diff then
                          vim.cmd.normal({x.key, bang = true})
                        else
                          gitsigns.nav_hunk(x.dir)
                        end
                    end,
                    opts
                )
            end
            -- Hunk actions
            vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk)
            vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk)
            -- vim.keymap.set("v", "<leader>hs", function() gitsigns.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end)
            -- vim.keymap.set("v", "<leader>hr", function() gitsigns.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end)
            vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk)
        end
    })
end

return {
    "lewis6991/gitsigns.nvim",
    config = configure_gitsigns,
}
