require('mason').setup({})
local lsp = require("lsp-zero")
local installer = require("lsp-zero.installer")
local expand_macro = require("expand_macro")

require("copilot").setup({
  -- suggestion = { enabled = false },
  -- panel = { enabled = true },
})


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

lsp.configure('rust_analyzer',  {
    settings = {
        ['rust-analyzer'] = {
            -- read cargo features from env CARGO_FEATURES and split by comma
            cargo = {
                features = vim.split(vim.env.CARGO_FEATURES or "", ',')
            },
        }
    }
})

lsp.setup_servers(installer.fn.get_servers())


local cmp = require('cmp')
local cmp_action = lsp.cmp_action()

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

cmp_mappings = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
})
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp_mappings,
    sources = {
        -- Copilot Source
        { name = "copilot", group_index = 2 },
        -- Other Sources
        { name = "nvim_lsp", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "luasnip", group_index = 2 },
    },
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
