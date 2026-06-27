-- ============================================================
-- Persistent toggleable terminal in a horizontal split.
-- Bound to <C-/> (and <C-_> for terminals that send that instead).
-- ============================================================

local state = { buf = -1, win = -1 }

local function buf_valid() return state.buf ~= -1 and vim.api.nvim_buf_is_valid(state.buf) end
local function win_valid() return state.win ~= -1 and vim.api.nvim_win_is_valid(state.win) end

local function toggle()
  if win_valid() then
    vim.api.nvim_win_hide(state.win)
    state.win = -1
    return
  end

  vim.cmd 'botright 15split'
  state.win = vim.api.nvim_get_current_win()

  if buf_valid() then
    vim.api.nvim_win_set_buf(state.win, state.buf)
  else
    vim.cmd.terminal()
    state.buf = vim.api.nvim_get_current_buf()
    vim.bo[state.buf].buflisted = false
  end

  vim.cmd 'startinsert'
end

-- Map both keycodes; terminals disagree on what Ctrl+/ sends.
for _, key in ipairs { '<C-/>', '<C-_>' } do
  vim.keymap.set({ 'n', 't', 'i' }, key, toggle, { desc = 'Toggle terminal' })
end
