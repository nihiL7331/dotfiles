-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
-- [[ Formatting ]]
vim.pack.add { gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  -- You can also specify external formatters in here.
  formatters_by_ft = {
    lua = { 'stylua' },
    cpp = { 'clang-format' },
    c = { 'clang-format' },
  },
  formatters = {
    ['clang-format'] = {
      prepend_args = { '--style={IndentWidth: 4}' },
    },
  },
}

vim.keymap.set(
  { 'n', 'v' },
  '<leader>F',
  function()
    require('conform').format {
      lsp_fallback = true,
      async = true,
      timeout_ms = 500,
    }
  end,
  { desc = '[F]ormat buffer' }
)
