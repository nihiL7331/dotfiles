-- ============================================================
-- <leader>r: run the current file based on its filetype.
-- Filetype -> function(file) -> shell command string.
-- ============================================================

local function esc(s) return vim.fn.shellescape(s) end
local function tmp() return vim.fn.tempname() end

local runners = {
  python     = function(f) return 'python3 ' .. esc(f) end,
  lua        = function(f) return 'lua ' .. esc(f) end,
  sh         = function(f) return 'bash ' .. esc(f) end,
  bash       = function(f) return 'bash ' .. esc(f) end,
  zsh        = function(f) return 'zsh ' .. esc(f) end,
  javascript = function(f) return 'node ' .. esc(f) end,
  typescript = function(f) return 'tsx ' .. esc(f) end,
  ruby       = function(f) return 'ruby ' .. esc(f) end,
  go         = function(f) return 'go run ' .. esc(f) end,
  c = function(f)
    local out = tmp()
    return ('cc %s -o %s && %s'):format(esc(f), esc(out), esc(out))
  end,
  cpp = function(f)
    local out = tmp()
    return ('c++ -std=c++20 %s -o %s && %s'):format(esc(f), esc(out), esc(out))
  end,
  rust = function(f)
    local out = tmp()
    return ('rustc %s -o %s && %s'):format(esc(f), esc(out), esc(out))
  end,
}

local function run()
  local ft = vim.bo.filetype
  local runner = runners[ft]
  if not runner then
    vim.notify(('No runner for filetype: %s'):format(ft == '' and '<none>' or ft), vim.log.levels.WARN)
    return
  end

  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('Buffer has no file on disk', vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then vim.cmd.write() end

  vim.cmd 'botright 15split'
  vim.cmd.terminal(runner(file))
  vim.bo.bufhidden = 'wipe'
  vim.cmd 'startinsert'
end

vim.keymap.set('n', '<leader>r', run, { desc = '[R]un current file' })
