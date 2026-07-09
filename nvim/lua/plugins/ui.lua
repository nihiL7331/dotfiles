-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
-- [[ Installing and Configuring Plugins ]]
--
-- To install a plugin simply call `vim.pack.add` with its git url.
-- This will download the default branch of the plugin, which will usually be `main` or `master`
-- You can also have more advanced specs, which we will talk about later.
--
-- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.

-- See `:help gitsigns` to understand what each configuration key does.
-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signcolumn = false,
  numhl = true,
  linehl = false,
  word_diff = false,
}

-- Useful plugin to show you pending keybinds.
vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

-- -- You can easily change to a different colorscheme.
-- -- Change the name of the colorscheme plugin below, and then
-- -- change the command under that to load whatever the name of that colorscheme is.
-- --
-- -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
-- --- @param repo_user string
-- --- @param name string
-- local function set_colorscheme(repo_user, name)
--   vim.pack.add { gh(repo_user .. '/' .. name .. '-nvim') }
--   vim.cmd.colorscheme(name)
-- end
--
-- set_colorscheme('savq', 'melange')

-- Highlight todo, notes, etc in comments
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { gh 'nvim-mini/mini.nvim' }

require('mini.pairs').setup()

-- [[ Colorscheme ]]

local active = require 'core.current_theme'
vim.cmd('colorscheme ' .. active)

-- If a nerd font is available, load the icons module for pretty icons in various plugins.
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
  MiniIcons.mock_nvim_web_devicons()
end

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

-- Circular paste buffer
vim.pack.add { gh 'gbprod/yanky.nvim' }
require('yanky').setup {
  ring = { history_length = 100 },
}
vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)', { desc = 'Put text after cursor' })
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)', { desc = 'Put text before cursor' })
vim.keymap.set('n', '[p', '<Plug>(YankyCycleForward)', { desc = 'Cycle forward through yank history' })
vim.keymap.set('n', ']p', '<Plug>(YankyCycleBackward)', { desc = 'Cycle backward through yank history' })

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- Set `use_icons` to true if you have a Nerd Font

local filename = function() return statusline.section_filename { trunc_width = 140 } end

statusline.setup {
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
      local fname = filename()
      return statusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { fname } },
        '%=',
      }
    end,
    inactive = function()
      return statusline.combine_groups {
        { hl = 'MiniStatuslineFilename', strings = { filename() } },
      }
    end,
  },
  use_icons = vim.g.have_nerd_font,
}

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim
