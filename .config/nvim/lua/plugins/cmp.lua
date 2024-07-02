-- Completions with nvim-cmp and friends
-- https://github.com/hrsh7th/nvim-cmp

local function configure_cmp()

    local cmp = require("cmp")
    local cmp_types = require("cmp.types")

    local source_mapping = {
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        path = "[Path]",
        buffer = "[Buffer]",
    }

    cmp.setup({
        -- Expand snippets with cmp_luasnip
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        -- Keybindings
        mapping = cmp.mapping.preset.insert({
            -- ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Insert })),
            -- This is to make <C-n> the hotkey for both initiating completion and select next item
            ["<C-n>"] = function(fallback)
                if cmp.visible() then
                cmp.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Insert })
                elseif (function()
                            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                        end)() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }),
            ["<C-f>"] = cmp.mapping.scroll_docs( 4),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-Space>"] = cmp.mapping.complete(), -- same as <C-n> above
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        -- TODO: Why are these separate? Priority?
        sources = cmp.config.sources(
            {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }
        ),
        completion = {
            keyword_length = 4,
            completeopt = "menu,menuone,noselect",
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = source_mapping[entry.source.name]
                return vim_item
            end,
        },
    })
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        {"hrsh7th/cmp-nvim-lsp"},
        {"hrsh7th/cmp-buffer"},
        {"hrsh7th/cmp-path"},
        -- Snippet engine(s) required for nvim-cmp (expands things from LS)
        {"L3MON4D3/LuaSnip"},
        {"saadparwaiz1/cmp_luasnip"},
    },
    config = configure_cmp,
}
