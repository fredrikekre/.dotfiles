-- Plugins that don't require any advanced config
return {
    "vim-airline/vim-airline",
    config = function()
        vim.g["airline_theme"] = "bubblegum"
        vim.g["airline#extensions#tabline#enabled"] = 1
        vim.g["airline_skip_empty_sections"] = 1
        vim.opt.showmode = false
    end,
    dependencies = {
        {"vim-airline/vim-airline-themes"},
    },
}
