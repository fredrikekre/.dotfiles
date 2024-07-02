-- fzf.vim, fzf
-- https://github.com/junegunn/fzf.vim
-- https://github.com/junegunn/fzf

return {
    "junegunn/fzf.vim",
    config = function()
        vim.keymap.set("n", "<C-F>", ":Rg!<CR>")
        -- TODO: Use vim.keymap.set
        vim.cmd("nnoremap <expr> <C-p> len(system('git rev-parse')) ? ':Files!<CR>' : ':GFiles!<CR>'")
    end,
    dependencies = {
        {"junegunn/fzf"},
    },
}
