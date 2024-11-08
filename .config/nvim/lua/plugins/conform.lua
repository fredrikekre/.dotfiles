-- https://github.com/stevearc/conform.nvim

local function configure_conform()
    local conform = require("conform")
    -- Keymaps
    vim.keymap.set({"n", "v"}, "<leader>f", function() conform.format({}) end, {silent = true})
    -- vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
    -- Configure conform
    local opts = {
        formatters_by_ft = {
            julia = {"runic"},
        },
        formatters = {
            runic = {
                command = "runic",
            },
        },
        default_format_opts = {
            timeout_ms = 10000,
        },
    }
    conform.setup(opts)
end

return {
    "stevearc/conform.nvim",
    config = configure_conform,
}
