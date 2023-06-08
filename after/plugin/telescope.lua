local telescope = require("telescope")
telescope.load_extension("ag") 
telescope.setup{
  pickers = {
    find_files = {
      theme = "ivy",
      hidden = "true"
    }
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { noremap = true })

