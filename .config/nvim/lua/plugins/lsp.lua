-- nvim-lspconfig, https://github.com/neovim/nvim-lspconfig

-- Set LSP keymappings in on_attach (i.e. only in buffers with LSP active)
-- TODO: lspconfig recommend doing this in an LspAttach autocommand instead
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>lca", function() vim.lsp.buf.code_action({apply = true}) end, opts)
    vim.keymap.set("n", "<leader>lqf", function() vim.lsp.buf.code_action({apply = true}) end, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("v", "<leader>lfmt", function() vim.lsp.buf.format({timeout_ms = 1000000}) end, opts)
end

-- Setup lspconfig: capabilities is passed to lspconfig.$server.setup
-- TODO: Why don't I have to make_client_capabilities and extend?
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local default_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
}

local servers = {
    -- Rust LSP (rust_analyzer)
    rust_analyzer = default_opts,
    -- C/C++ LSP (clangd)
    clangd = default_opts,
    -- Go LSP (gopls)
    gopls = default_opts,
    -- YAML LSP (yaml-language-server)
    yamlls = default_opts,
    -- Ansible LSP (ansible-language-server)
    ansiblels = default_opts,
    -- Terraform LSP (terraform-ls)
    terraformls = default_opts,
    -- Julia LSP (LanguageServer.jl)
    julials = vim.tbl_extend(
        "force",
        default_opts,
        {
            on_new_config = function(new_config, _)
                local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
                local REVISE_LANGUAGESERVER = false
                if REVISE_LANGUAGESERVER then
                    new_config.cmd[5] = (new_config.cmd[5]):gsub("using LanguageServer", "using Revise; using LanguageServer; LanguageServer.USE_REVISE[] = true")
                elseif require("lspconfig").util.path.is_file(julia) then
                    new_config.cmd[1] = julia
                end
            end,
            -- This just adds dirname(fname) as a fallback (see nvim-lspconfig#1768).
            root_dir = function(fname)
                local util = require("lspconfig.util")
                return util.root_pattern "Project.toml"(fname) or util.find_git_ancestor(fname) or
                    util.path.dirname(fname)
            end,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                -- Disable automatic formatexpr since the LS.jl formatter isn't so nice.
                vim.bo[bufnr].formatexpr = ""
            end,
        }
    ),
}

local function configure_lsp()
    lspconfig = require("lspconfig")
    for name, opts in pairs(servers) do
        lspconfig[name].setup(opts)
    end
end

return {
    "neovim/nvim-lspconfig",
    config = configure_lsp,
}
