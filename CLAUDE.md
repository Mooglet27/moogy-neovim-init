# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration written in Lua, using the lazy.nvim plugin manager. The configuration follows a modular structure with separate files for different aspects of the editor setup.

## Architecture

### Entry Point

- `init.lua` - Main entry point that loads all configuration modules and sets up diagnostics

### Configuration Structure

- `lua/config/` - Core configuration modules
  - `basic.lua` - Basic Vim options (line numbers, tabs, indentation, search, etc.)
  - `keymap.lua` - Custom key mappings and shortcuts
  - `lazy.lua` - Plugin manager setup and simple plugin configurations

### Plugin Configuration

- `lua/plugins/` - Individual plugin configurations as separate modules
  - `lsp.lua` - LSP setup using vim.lsp.config API with Mason integration
  - `formatter.lua` - Code formatting with format-on-save
  - `telescope.lua` - Fuzzy finder and file browser
  - `colorscheme.lua` - Theme configuration
  - `treesitter.lua` - Syntax highlighting
  - `lualine.lua` - Status line
  - `trouble.lua` - Diagnostic viewer
  - `noice.lua` - UI enhancements
  - `tailwind-tools.lua` - Tailwind CSS utilities
  - `go.lua` - Go-specific configuration

### File-Type Specific Settings

- `after/ftplugin/` - Language-specific configurations for tab widths and formatting

## Key Configuration Details

### LSP Setup

- Uses modern `vim.lsp.config` API instead of lspconfig
- Configured servers: pyright, ruff, clangd, eslint, tailwindcss, ts_ls, lua_ls, gopls
- Mason automatically installs language servers
- Format-on-save enabled for Python, TOML, and Go files

### Plugin Manager

- Uses lazy.nvim for plugin management
- Plugins are lazy-loaded based on events, filetypes, or commands
- Lock file: `lazy-lock.json`

### Key Mappings

- Leader key: `<Space>`
- Custom navigation, editing, and LSP keybindings defined in `lua/config/keymap.lua`
- Tmux integration for seamless pane navigation

### Formatting

- Automatic formatting via formatter.nvim
- Language-specific formatters: isort (Python), stylua (Lua), prettierd (JS/TS/JSON/Markdown), clang-format (C/C++)
- Format-on-save autocommand

## Common Development Commands

Since this is a Neovim configuration (not a project with build commands), the main "commands" are Neovim operations:

### Plugin Management

```lua
:Lazy sync    -- Update all plugins
:Lazy clean   -- Remove unused plugins
:Lazy check   -- Check for plugin updates
```

### LSP Operations

```lua
:LspInfo      -- Show LSP client info
:Mason        -- Open Mason installer UI
```

### Testing Configuration

To test configuration changes, restart Neovim or reload specific modules using `:luafile %` when editing Lua files.

## Development Workflow

1. Edit configuration files in `lua/config/` or `lua/plugins/`
2. Restart Neovim to apply changes
3. Use `:Lazy sync` to update plugins after modifying plugin specifications
4. Check `:checkhealth` for configuration issues
