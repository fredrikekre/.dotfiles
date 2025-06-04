-- nvim-lspconfig, https://github.com/neovim/nvim-lspconfig

-- Note: The server configuration in this file is done in the
-- nvim-lspconfig.config() setup function. This is a bit strange but at least
-- it ensures the config is run *after* configuring the plugin...

-- TODO: Unclear whether this is needed or not. Completions seem to work anyway?
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function config()
    -- Configure an autocommand which fires when a server attaches to a buffer
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local opts = { buffer = args.buf, silent = true }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>lca", function() vim.lsp.buf.code_action({apply = true}) end, opts)
            vim.keymap.set("n", "<leader>lqf", function() vim.lsp.buf.code_action({apply = true}) end, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("v", "<leader>lfmt", function() vim.lsp.buf.format({timeout_ms = 1000000}) end, opts)
        end,
    })
    -- Julia LSP (LanguageServer.jl)
    do
        -- Modify the julia binary to out custom built one if it exists
        local cfg = vim.lsp.config.julials
        local cmd = cfg.cmd
        local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
        local REVISE_LANGUAGESERVER = false
        if REVISE_LANGUAGESERVER then
            cmd[5] = (cmd[5]):gsub("using LanguageServer", "using Revise; using LanguageServer; LanguageServer.USE_REVISE[] = true")
        elseif require("lspconfig").util.path.is_file(julia) then
            cmd[1] = julia
        end
        vim.lsp.config('julials', {
            cmd = cmd,
            on_attach = function(client, bufnr)
                -- Disable automatic formatexpr since the LS.jl formatter isn't very nice.
                vim.bo[bufnr].formatexpr = ""
            end,
            -- -- This just adds dirname(fname) as a fallback (see nvim-lspconfig#1768).
            -- root_dir = function(fname)
            --     local util = require("lspconfig.util")
            --     return util.root_pattern "Project.toml"(fname) or util.find_git_ancestor(fname) or
            --         util.path.dirname(fname)
            -- end,
        })
        vim.lsp.enable("julials")
    end
    -- Enable some more servers. These don't need special handling, yey!
    vim.lsp.enable({
        "ansiblels",     -- Ansible LSP (ansible-language-server)
        "clangd",        -- C/C++ LSP (clangd)
        "clangd",        -- C/C++ LSP (clangd)
        "gopls",         -- Go LSP (gopls)
        "pylsp",         -- Python LSP (python-lsp-server)
        "rust_analyzer", -- Rust LSP (rust_analyzer)
        "terraformls",   -- Terraform LSP (terraform-ls)
        "yamlls",        -- YAML LSP (yaml-language-server)
    })
end

return {
    "neovim/nvim-lspconfig",
    config = config,
}
