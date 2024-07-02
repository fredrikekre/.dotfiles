-- fzf.vim, fzf
-- https://github.com/junegunn/fzf.vim
-- https://github.com/junegunn/fzf

return {
    "junegunn/fzf.vim",
    commit = "1e054c1d075d87903647db9320116d360eb8b024",
    config = function()
        vim.keymap.set("n", "<C-F>", ":Rg!<CR>")
        -- TODO: Use vim.keymap.set
        vim.cmd("nnoremap <expr> <C-p> len(system('git rev-parse')) ? ':Files!<CR>' : ':GFiles!<CR>'")
    end,
    dependencies = {
        {"junegunn/fzf", commit = "952b6af4454ed55626d78e3845c6b5b640ac831d"},
    },
}
