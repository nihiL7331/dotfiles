-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
require 'core.options'
-- ============================================================
-- SECTION 2: KEYMAPS
-- basic keymaps
-- ============================================================
require 'core.keymaps'
-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
require 'core.pack_init'
-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
require 'plugins.ui'
-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
require 'plugins.telescope'
-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
require 'plugins.lsp'
-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
require 'plugins.formatting'
-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
require 'plugins.completion'
-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
require 'plugins.treesitter'
-- ============================================================
-- SECTION 10: OIL
-- Download, setup and keymaps for oil.nvim
-- ============================================================
require 'plugins.oil'
-- ============================================================
-- SECTION 11: TERMINAL
-- <C-/> toggleable horizontal-split terminal
-- ============================================================
require 'core.terminal'
