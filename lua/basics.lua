vim.g.mapleader      = " "
vim.o.number         = true
vim.o.relativenumber = true
vim.o.wrap           = false
vim.o.expandtab      = true
vim.o.incsearch      = true
vim.o.tabstop        = 4
vim.o.cursorline     = true
vim.o.ignorecase     = true
vim.o.hlsearch       = false
vim.o.swapfile       = false
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.scrolloff      = 3
vim.o.errorbells     = false
vim.o.shiftwidth     = 4
vim.o.numberwidth    = 4
vim.o.termguicolors  = true
vim.o.colorcolumn    = '80'
vim.o.showmode       = false
vim.o.showtabline    = 2
vim.o.signcolumn     = 'yes'
vim.o.mouse          = 'a'
-- Setup clipboard
if vim.fn.has('unix') == 1 and vim.fn.executable('wl-copy') == 1 and vim.fn.executable('wl-paste') == 1 then
    vim.g.clipboard = {
        name = 'wl-clipboard',
        copy = {
            ['+'] = 'wl-copy',
            ['*'] = 'wl-copy',
        },
        paste = {
            ['+'] = 'wl-paste -n',
            ['*'] = 'wl-paste -n',
        },
        cache_enabled = 0,
    }
    vim.o.clipboard = 'unnamedplus'
else
    vim.o.clipboard = 'unnamedplus'
end
vim.o.exrc           = true

vim.api.nvim_set_keymap('n', 'vs', ':vs<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'sp', ':sp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tn', ':tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tk', ':tabnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tj', ':tabprev<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'to', ':tabo<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S>', ':%s/', { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":sp<CR> :term<CR> :resize 20N<CR> i", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>tt", ':Trouble diagnostics toggle<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "<F8>", ":AerialToggle right<CR>", {noremap=true, silent=true})

vim.g["netrw_banner"]    = 0
vim.g["netrw_liststyle"] = 3
vim.g["netrw_winsize"]   = 25
