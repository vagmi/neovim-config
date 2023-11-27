require('mason').setup({})
local lsp = require("lsp-zero")
local rt = require("rust-tools")
local expand_macro = require("rust-tools.expand_macro")
local rt_utils = require("rust-tools.utils.utils")
local util = require('lspconfig/util')
rt.utils = rt_utils

lsp.preset("recommended")


require('mason-lspconfig').setup({
    -- Replace the language servers listed here 
    -- with the ones you want to install
    ensure_installed = {
        'tsserver',
        'lua_ls',
        'rust_analyzer',
        'kotlin_language_server',
    },
    handlers = {
        lsp.default_setup,
    },
})

print(vim.split(package.path, ';'))
-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            completion = {enable = true, callSnippet = "Both"},
            diagnostics = {
                enable = true,
                globals = {'vim'},
                disable = {"lowercase-global"}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME .. '/lua',
                    vim.env.VIMRUNTIME .. '/lua/vim',
                    vim.env.VIMRUNTIME .. '/lua/vim/lsp',
                    require('packer').config.package_root
                }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_action = lsp.cmp_action()

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    })
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
  if client.name == "eslint" then
      vim.cmd.LspStop('eslint')
      return
  end
  vim.lsp.inlay_hint.enable(bufnr, true)

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

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

require("luasnip.loaders.from_lua").load({paths = "~/.config/snippets"})
