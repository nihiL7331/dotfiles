vim.pack.add { gh 'stevearc/oil.nvim' }

require('oil').setup {
  default_file_explorer = true,

  skip_confirm_for_simple_edits = true,

  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _) return name == '..' or name == '.git' end,
  },
}

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
