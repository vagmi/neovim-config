# Neovim Configuration

This is a comprehensive Neovim configuration written entirely in Lua, designed to provide a powerful, IDE-like experience for various programming tasks, with a particular focus on Rust development.

## Features

- **Plugin Management**: Uses Packer for efficient plugin management.
- **LSP Integration**: Configured for multiple languages, providing auto-completion, diagnostics, and code navigation.
- **Syntax Highlighting**: Enhanced with Treesitter for better code parsing and highlighting.
- **Fuzzy Finding**: Telescope integration for quick file and text searching.
- **File Explorer**: NvimTree for easy project navigation.
- **Git Integration**: Seamless Git operations with fugitive.
- **Debugging**: DAP setup for interactive debugging sessions.
- **AI Assistance**: NeoAI integration for AI-powered coding help and text generation.
- **Custom Keybindings**: Intuitive keymaps for improved workflow.
- **Statusline**: Customized with lualine for better visual feedback.
- **Theme**: Configurable color scheme (currently set to TokyoBones).
- **Language-Specific Setups**: Tailored configurations for languages like Rust.

## Installation

1. Ensure you have Neovim 0.11+ installed. I simply use the HEAD and build from source.
2. Back up your existing Neovim configuration if you have one.
3. Clone this repository into your Neovim configuration directory:
   ```
   git clone https://github.com/vagmi/neovim-config.git ~/.config/nvim
   ```
4. Install Packer:
   ```
   git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
   ```
5. Open Neovim and run `:PackerSync` to install all plugins.

## Usage

- Space is set as the leader key.
- Use `<leader>ff` to find files, `<leader>fg` for live grep, `<leader>fb` for buffer search.
- `<leader>x` toggles the file explorer.
- LSP features are automatically enabled for supported languages.

## Customization

- Modify `lua/basics.lua` for basic Neovim settings.
- Add or modify plugin configurations in the `after/plugin/` directory.
- Adjust keybindings and plugin settings to suit your preferences.
