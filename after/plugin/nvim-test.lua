require('nvim-test').setup()

vim.api.nvim_set_keymap("n", "cit", ':TestNearest<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "cif", ':TestFile<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "cil", ':TestLast<CR>', {noremap=true, silent=true})
