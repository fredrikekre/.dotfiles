-- https://github.com/stevearc/oil.nvim

-- For toggling detailed view
local detail = false

return {
    "stevearc/oil.nvim",
    dependencies = {
        {"nvim-tree/nvim-web-devicons"},
    },
    opts = {
        columns = {
            "icon",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            -- Disable these since they are used for navigation
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<C-p>"] = false,
            -- Toggle detailed view with <leader>d
            ["<leader>d"] = {
                callback = function()
                    detail = not detail
                    local cols = {"icon"}
                    if detail then
                        cols = {"icon", "permissions", "size", "mtime"}
                    end
                    require("oil").set_columns(cols)
                end,
            },
        },
    },
}
