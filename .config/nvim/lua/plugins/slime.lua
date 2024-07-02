-- vim-slime, https://github.com/jpalardy/vim-slime

-- This expands {last} to a fixed pane id. This is done in the override function
-- in order to delay the expansion until first usage instead of when Vim starts.
-- TODO: Luaify this? Define this as a lua function, register it to be called
--       from vimscript by the plugin?
vim.cmd([[
    function! SlimeOverrideConfig()
        let l:last_pane_id = trim(system('tmux display -pt "{last}" "#{pane_id}"'))
        let b:slime_config = {"socket_name": "default", "target_pane": l:last_pane_id}
    endfunction
]]
)

return {
    "jpalardy/vim-slime",
    config = function()
        vim.g["slime_target"] = "tmux"
        vim.g["slime_bracketed_paste"] = 1
        vim.keymap.set("n", "<S-CR>", "<Plug>SlimeParagraphSend")
        vim.keymap.set("x", "<S-CR>", "<Plug>SlimeRegionSend")
    end,
}
