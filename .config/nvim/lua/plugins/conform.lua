-- https://github.com/stevearc/conform.nvim

local function configure_conform()
    local conform = require("conform")
    -- Keymaps
    vim.keymap.set(
        {"n", "v"},
        "<leader>f",
        function()
            conform.format(
            {},
            function(err)
                if not err then
                    local mode = vim.api.nvim_get_mode().mode
                    if vim.startswith(string.lower(mode), "v") then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                    end
                end
            end
            )
        end,
        {silent = true}
    )
    -- vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
    -- Configure conform
    local opts = {
        formatters_by_ft = {
            julia = {"runic"},
        },
        default_format_opts = {
            timeout_ms = 10000,
        },
    }
    conform.setup(opts)
end

return {
    "stevearc/conform.nvim",
    commit = "db8a4a9edb217067b1d7a2e0362c74bfe9cc944d",
    config = configure_conform,
}
