-- Docs: https://github.com/junegunn/vim-easy-align/blob/master/EXAMPLES.md
return {
    "junegunn/vim-easy-align",
    config = function()
        vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
        vim.keymap.set("v", "ga", "<Plug>(EasyAlign)")
    end,
}
