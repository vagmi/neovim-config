local parser_config = require "nvim-treesitter.parsers".get_parser_configs()


 require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "javascript", "typescript", "c", "lua", "rust", "kotlin" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
parser_config.psql = {
    install_info = {
        url = "https://github.com/m-novikov/tree-sitter-sql",
        branch = "main",
        files = {"src/parser.c", "src/scanner.cc"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    },
  filetype = "sql", -- if filetype does not match the parser name
}

parser_config.d2 = {
  install_info = {
    url = 'https://codeberg.org/p8i/tree-sitter-d2.git',
    revision = 'main',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'd2',
};
require("nvim-treesitter.install").prefer_git = true

vim.o.foldmethod='expr'
vim.o.foldexpr='nvim_treesitter#foldexpr()'
vim.o.foldenable=false
