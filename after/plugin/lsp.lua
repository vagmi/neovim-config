require('mason').setup({})
local lsp = require("lsp-zero")
local lspconfig = require('lspconfig')
local lspconfig_defaults = require('lspconfig').util.default_config
local expand_macro = require("expand_macro")

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

require("copilot").setup()


require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
    },
    handlers = {
        lsp.default_setup,
    },
})


lsp.configure('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            -- read cargo features from env CARGO_FEATURES and split by comma
            cargo = {
                features = vim.split(vim.env.CARGO_FEATURES or "", ',')
            },
        }
    }
})



local cmp = require('cmp')
local cmp_action = lsp.cmp_action()

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
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
        { name = "copilot",  group_index = 2 },
        -- Other Sources
        { name = "elespee",  group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "path",     group_index = 2 },
        { name = "luasnip",  group_index = 2 },
    },
})


-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("v", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<Leader>vrn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        -- Format using black for Python, fallback to LSP for other files
        vim.keymap.set({ 'n', 'x' }, '<F3>', function()
            if vim.bo.filetype == "python" and vim.fn.executable('black') == 1 then
                print('using black for formatting')
                vim.cmd('silent !black --quiet "%"')
                vim.cmd('edit') -- reload the file
            else
                vim.lsp.buf.format({async = true})
            end
        end, opts)
        vim.keymap.set('n', '<Leader>vca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

        if client.name == 'rust_analyzer' then
            vim.keymap.set("n", "<Leader>m", expand_macro.expand_macro, { buffer = event.buf})
            vim.keymap.set("v", "<Leader>f", expand_macro.extract_function, { buffer = event.buf})
        end
    end,
})

lsp.setup()
vim.lsp.inlay_hint.enable(true)

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
        if server_name=='lua_ls' then
            lspconfig[server_name].setup {
                on_init = function(client)
                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
                        completion = { enable = true, callSnippet = "Both" },
                        diagnostics = {
                            enable = true,
                            globals = { 'vim' },
                            disable = { "lowercase-global" }
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

                    })
                end,
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
                        completion = { enable = true, callSnippet = "Both" },
                        diagnostics = {
                            enable = true,
                            globals = { 'vim' },
                            disable = { "lowercase-global" }
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
            }
        else
            require('lspconfig')[server_name].setup({})
        end

    end,
  },
})


vim.diagnostic.config({
    virtual_text = true,
})


require("luasnip.loaders.from_lua").load({ paths = "~/.config/snippets" })


