set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF

-- Setup nvim-cmp.
vim.opt.completeopt = {"menu", "menuone", "noselect"}

local cmp = require('cmp')
local cmp_types = require('cmp.types')
local source_mapping = {buffer = '[Buffer]', nvim_lsp = '[LSP]'}

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Insert })),
        -- This is to make <C-n> the hotkey for both initiating completion and select next item
        ['<C-n>'] = function(fallback)
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
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }),
        ['<C-f>'] = cmp.mapping.scroll_docs( 4),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-Space>'] = cmp.mapping.complete(), -- same as <C-n> above
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    {
        { name = 'buffer' },
    }),
    completion = {keyword_length = 4},
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = source_mapping[entry.source.name]
            return vim_item
        end,
    },
})

-- Setup lspconfig: capabilities is passed to lspconfig.$server.setup
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Set LSP keymappings in on_attach (i.e. only in buffers with LSP active)
local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lrr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lqf', '<cmd>lua vim.lsp.buf.code_action({apply = true})<CR>', opts)
end

-- Julia LSP (LanguageServer.jl)
local REVISE_LANGUAGESERVER = false
require'lspconfig'.julials.setup({
    on_new_config = function(new_config, _)
        local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
        if REVISE_LANGUAGESERVER then
            new_config.cmd[5] = (new_config.cmd[5]):gsub("using LanguageServer", "using Revise; using LanguageServer; if isdefined(LanguageServer, :USE_REVISE); LanguageServer.USE_REVISE[] = true; end")
        elseif require'lspconfig'.util.path.is_file(julia) then
            new_config.cmd[1] = julia
        end
    end,
    -- This just adds dirname(fname) as a fallback (see nvim-lspconfig#1768).
    root_dir = function(fname)
        local util = require'lspconfig.util'
        return util.root_pattern 'Project.toml'(fname) or util.find_git_ancestor(fname) or
               util.path.dirname(fname)
    end,
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Rust LSP (rust_analyzer)
require('lspconfig').rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- null-ls
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.shellcheck,
    },
})


require('gitsigns').setup({
    signs = {
        add = { text = '+'},
        change = { text = '±'},
    },
    on_attach = function(bufnr)
        -- Hunk navigation
        local opts = { expr=true, noremap=true, silent=true, }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", opts)
    end,

})

-- require('coverage').setup()

EOF
