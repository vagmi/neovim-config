require('nvim-tree').setup({
    renderer = {
        group_empty = true,
    }, 
    git = {
        enable = true,
        ignore = false
    }
})

vim.api.nvim_set_keymap("n", "<leader>x", ":NvimTreeToggle<CR>", {noremap = true, silent = true})
