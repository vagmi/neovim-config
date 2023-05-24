local lsp = require("lsp-zero")
local rt = require("rust-tools")
local expand_macro = require("rust-tools.expand_macro")
local rt_utils = require("rust-tools.utils.utils")
local util = require('lspconfig/util')
rt.utils = rt_utils

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'lua_ls',
  'rust_analyzer',
  'kotlin_language_server',
  'solargraph'
})

print(vim.split(package.path, ';'))
-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            completion = {enable = true, callSnippet = "Both"},
            diagnostics = {
                enable = true,
                globals = {'vim', 'describe'},
                disable = {"lowercase-global"}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            }
        }
    }
})


local cmp = require('cmp')
local ih = require("inlay-hints")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  ih.on_attach(client, bufnr)
  if client.name == "eslint" then
      vim.cmd.LspStop('eslint')
      return
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  if client.name == 'rust_analyzer' then
     vim.keymap.set("n", "<Leader>m", expand_macro.expand_macro, { buffer = bufnr })
  end
end)

require('lspconfig').tsserver.setup({
    root_dir = util.root_pattern('.git')
})

ih.setup({
  eol = {
    right_align = true,
  }
})
lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
vim.o.winbar = require('lspsaga.symbolwinbar'):get_winbar()
require("luasnip.loaders.from_lua").load({paths = "~/.config/snippets"})
