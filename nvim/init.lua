-- ==============================================================================
-- Lightweight Neovim Configuration (Neovim 0.12+)
-- ==============================================================================

-- 1. Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick buffer toggle (alternate file)
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Toggle alternate buffer" })

-- 2. Theme & Presentation Mode (<leader>l, <leader>th)
local theme_file = vim.fn.stdpath("state") .. "/theme.txt"

local themes = {
  { id = "oled-dark",            name = "OLED Black (Pure #000000)", bg = "dark",  pair = "oled-light" },
  { id = "oled-light",           name = "OLED White (Pure #ffffff)", bg = "light", pair = "oled-dark" },
  { id = "tokyonight-night",     name = "Tokyo Night (Night)",       bg = "dark",  pair = "tokyonight-day" },
  { id = "tokyonight-storm",     name = "Tokyo Night (Storm)",       bg = "dark",  pair = "tokyonight-day" },
  { id = "tokyonight-moon",      name = "Tokyo Night (Moon)",        bg = "dark",  pair = "tokyonight-day" },
  { id = "tokyonight-day",       name = "Tokyo Night (Day - Light)", bg = "light", pair = "tokyonight-night" },
  { id = "catppuccin-mocha",     name = "Catppuccin (Mocha)",        bg = "dark",  pair = "catppuccin-latte" },
  { id = "catppuccin-macchiato", name = "Catppuccin (Macchiato)",    bg = "dark",  pair = "catppuccin-latte" },
  { id = "catppuccin-frappe",    name = "Catppuccin (Frappe)",       bg = "dark",  pair = "catppuccin-latte" },
  { id = "catppuccin-latte",     name = "Catppuccin (Latte - Light)",bg = "light", pair = "catppuccin-mocha" },
  { id = "kanagawa-wave",        name = "Kanagawa (Wave)",           bg = "dark",  pair = "kanagawa-lotus" },
  { id = "kanagawa-dragon",      name = "Kanagawa (Dragon)",         bg = "dark",  pair = "kanagawa-lotus" },
  { id = "kanagawa-lotus",       name = "Kanagawa (Lotus - Light)",  bg = "light", pair = "kanagawa-wave" },
  { id = "rose-pine-main",       name = "Rose Pine (Main)",          bg = "dark",  pair = "rose-pine-dawn" },
  { id = "rose-pine-moon",       name = "Rose Pine (Moon)",          bg = "dark",  pair = "rose-pine-dawn" },
  { id = "rose-pine-dawn",       name = "Rose Pine (Dawn - Light)",  bg = "light", pair = "rose-pine-main" },
  { id = "gruvbox-dark",         name = "Gruvbox (Dark)",            bg = "dark",  pair = "gruvbox-light" },
  { id = "gruvbox-light",        name = "Gruvbox (Light)",           bg = "light", pair = "gruvbox-dark" },
}

local theme_map = {}
for _, t in ipairs(themes) do
  theme_map[t.id] = t
end

local function apply_custom_highlights()
  -- Line status colors on line numbers (Diagnostics: Errors > Warnings > Info > Hint)
  vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { fg = "#ef4444", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn",  { fg = "#f59e0b", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo",  { fg = "#3b82f6" })
  vim.api.nvim_set_hl(0, "DiagnosticLineNrHint",  { fg = "#10b981" })

  -- Git status colors on line numbers (mini.diff)
  vim.api.nvim_set_hl(0, "MiniDiffSignAdd",    { fg = "#10b981", bold = true })
  vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#3b82f6", bold = true })
  vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#f43f5e", bold = true })

  -- Colored underlines and undercurls for diagnostics
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, underline = true, sp = "#ef4444" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, underline = true, sp = "#f59e0b" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { undercurl = true, underline = true, sp = "#3b82f6" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { undercurl = true, underline = true, sp = "#10b981" })


  -- LSP Signature active parameter highlight (prominent bold underline)
  vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = "#38bdf8", bold = true, underline = true })
end

local function apply_mode_colors()
  vim.api.nvim_set_hl(0, "ModeNormal",   { fg = "#ffffff", bg = "#3b82f6", bold = true })
  vim.api.nvim_set_hl(0, "ModeInsert",   { fg = "#ffffff", bg = "#10b981", bold = true })
  vim.api.nvim_set_hl(0, "ModeVisual",   { fg = "#ffffff", bg = "#8b5cf6", bold = true })
  vim.api.nvim_set_hl(0, "ModeReplace",  { fg = "#ffffff", bg = "#ef4444", bold = true })
  vim.api.nvim_set_hl(0, "ModeCommand",  { fg = "#ffffff", bg = "#f59e0b", bold = true })
  vim.api.nvim_set_hl(0, "ModeTerminal", { fg = "#ffffff", bg = "#06b6d4", bold = true })
  apply_custom_highlights()
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    apply_custom_highlights()
  end,
})

local function apply_oled_dark()
  vim.o.background = "dark"
  vim.api.nvim_set_hl(0, "Normal",        { bg = "#000000", fg = "#e0e0e0" })
  vim.api.nvim_set_hl(0, "NormalFloat",   { bg = "#000000", fg = "#e0e0e0" })
  vim.api.nvim_set_hl(0, "SignColumn",    { bg = "#000000" })
  vim.api.nvim_set_hl(0, "LineNr",        { bg = "#000000", fg = "#555555" })
  vim.api.nvim_set_hl(0, "CursorLine",    { bg = "#111111" })
  vim.api.nvim_set_hl(0, "CursorLineNr",  { bg = "#111111", fg = "#ffffff", bold = true })
  vim.api.nvim_set_hl(0, "EndOfBuffer",   { bg = "#000000", fg = "#000000" })
  vim.api.nvim_set_hl(0, "MsgArea",       { bg = "#000000", fg = "#ffffff" })
  vim.api.nvim_set_hl(0, "StatusLine",    { bg = "#000000", fg = "#000000" })
  vim.api.nvim_set_hl(0, "StatusLineNC",  { bg = "#000000", fg = "#000000" })
  vim.api.nvim_set_hl(0, "WinSeparator",  { bg = "#000000", fg = "#222222" })
  vim.api.nvim_set_hl(0, "FloatBorder",   { bg = "#000000", fg = "#333333" })
  vim.api.nvim_set_hl(0, "Cursor",        { bg = "#ffffff", fg = "#000000" })
end

local function apply_oled_light()
  vim.o.background = "light"
  vim.api.nvim_set_hl(0, "Normal",        { bg = "#ffffff", fg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "NormalFloat",   { bg = "#ffffff", fg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "SignColumn",    { bg = "#ffffff" })
  vim.api.nvim_set_hl(0, "LineNr",        { bg = "#ffffff", fg = "#888888" })
  vim.api.nvim_set_hl(0, "CursorLine",    { bg = "#f4f4f4" })
  vim.api.nvim_set_hl(0, "CursorLineNr",  { bg = "#f4f4f4", fg = "#000000", bold = true })
  vim.api.nvim_set_hl(0, "EndOfBuffer",   { bg = "#ffffff", fg = "#ffffff" })
  vim.api.nvim_set_hl(0, "MsgArea",       { bg = "#ffffff", fg = "#000000" })
  vim.api.nvim_set_hl(0, "StatusLine",    { bg = "#ffffff", fg = "#ffffff" })
  vim.api.nvim_set_hl(0, "StatusLineNC",  { bg = "#ffffff", fg = "#ffffff" })
  vim.api.nvim_set_hl(0, "WinSeparator",  { bg = "#ffffff", fg = "#dddddd" })
  vim.api.nvim_set_hl(0, "FloatBorder",   { bg = "#ffffff", fg = "#cccccc" })
  vim.api.nvim_set_hl(0, "Cursor",        { bg = "#000000", fg = "#ffffff" })
end

local function load_saved_theme()
  local f = io.open(theme_file, "r")
  if f then
    local content = f:read("*a")
    f:close()
    if content then
      content = content:gsub("%s+", "")
      if theme_map[content] then return content end
    end
  end
  return "oled-dark"
end

local current_theme_id = "oled-dark"

local function apply_theme(id, save)
  id = id or "oled-dark"
  if not theme_map[id] then id = "oled-dark" end

  if id == "oled-dark" then
    apply_oled_dark()
  elseif id == "oled-light" then
    apply_oled_light()
  elseif id == "gruvbox-dark" then
    vim.o.background = "dark"
    pcall(vim.cmd.colorscheme, "gruvbox")
  elseif id == "gruvbox-light" then
    vim.o.background = "light"
    pcall(vim.cmd.colorscheme, "gruvbox")
  elseif id == "rose-pine-main" or id == "rose-pine" then
    pcall(vim.cmd.colorscheme, "rose-pine-main")
  elseif id == "rose-pine-moon" then
    pcall(vim.cmd.colorscheme, "rose-pine-moon")
  elseif id == "rose-pine-dawn" then
    pcall(vim.cmd.colorscheme, "rose-pine-dawn")
  else
    pcall(vim.cmd.colorscheme, id)
  end

  current_theme_id = id
  apply_mode_colors()

  if vim.o.background == "dark" then
    io.stdout:write("\027]12;#ffffff\007")
  else
    io.stdout:write("\027]12;#000000\007")
  end

  if save then
    local f = io.open(theme_file, "w")
    if f then
      f:write(id)
      f:close()
    end
  end
end

-- Reset terminal cursor on exit
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    io.stdout:write("\027]112\007")
  end,
})

-- Initialize saved theme
current_theme_id = load_saved_theme()
apply_theme(current_theme_id, false)

-- Single Letter Mode Indicator with Colored Background Badge
local mode_info = {
  n = { " N ", "ModeNormal" },
  no = { " N ", "ModeNormal" },
  nov = { " N ", "ModeNormal" },
  noV = { " N ", "ModeNormal" },
  ["no\22"] = { " N ", "ModeNormal" },
  niI = { " N ", "ModeNormal" },
  niR = { " N ", "ModeNormal" },
  niV = { " N ", "ModeNormal" },
  nt = { " N ", "ModeNormal" },
  ntT = { " N ", "ModeNormal" },
  v = { " V ", "ModeVisual" },
  vs = { " V ", "ModeVisual" },
  V = { " V ", "ModeVisual" },
  Vs = { " V ", "ModeVisual" },
  ["\22"] = { " V ", "ModeVisual" },
  ["\22s"] = { " V ", "ModeVisual" },
  s = { " S ", "ModeVisual" },
  S = { " S ", "ModeVisual" },
  ["\19"] = { " S ", "ModeVisual" },
  i = { " I ", "ModeInsert" },
  ic = { " I ", "ModeInsert" },
  ix = { " I ", "ModeInsert" },
  R = { " R ", "ModeReplace" },
  Rc = { " R ", "ModeReplace" },
  Rx = { " R ", "ModeReplace" },
  Rv = { " R ", "ModeReplace" },
  Rvc = { " R ", "ModeReplace" },
  Rvx = { " R ", "ModeReplace" },
  c = { " C ", "ModeCommand" },
  cv = { " C ", "ModeCommand" },
  ce = { " C ", "ModeCommand" },
  r = { " R ", "ModeReplace" },
  rm = { " M ", "ModeNormal" },
  ["r?"] = { " ? ", "ModeNormal" },
  ["!"] = { " ! ", "ModeCommand" },
  t = { " T ", "ModeTerminal" },
}

_G.get_mode_statusline = function()
  local m = vim.fn.mode()
  local info = mode_info[m] or { " " .. m:sub(1, 1):upper() .. " ", "ModeNormal" }
  return "%#" .. info[2] .. "#" .. info[1] .. "%#StatusLine#"
end

local function toggle_theme()
  local th = theme_map[current_theme_id]
  local target = th and th.pair or "oled-light"
  apply_theme(target, true)
  local name = theme_map[target] and theme_map[target].name or target
  vim.notify(name, vim.log.levels.INFO)
end
vim.keymap.set("n", "<leader>l", toggle_theme, { desc = "Toggle light/dark" })

local function pick_theme()
  local pick_items = {}
  for _, th in ipairs(themes) do
    table.insert(pick_items, {
      text = string.format("%s%s", th.id == current_theme_id and "* " or "  ", th.name),
      theme = th,
    })
  end

  require("mini.pick").start({
    source = {
      items = pick_items,
      name = "Select Theme",
      choose = function(selected)
        if not selected then return end
        apply_theme(selected.theme.id, true)
        vim.notify(selected.theme.name, vim.log.levels.INFO)
      end,
    },
  })
end

vim.keymap.set("n", "<leader>th", pick_theme, { desc = "Select theme" })

vim.api.nvim_create_user_command("Theme", function(opts)
  local arg = opts.args
  if arg and arg ~= "" then
    if theme_map[arg] then
      apply_theme(arg, true)
      vim.notify(theme_map[arg].name, vim.log.levels.INFO)
    else
      vim.notify("unknown theme: " .. arg, vim.log.levels.WARN)
    end
  else
    pick_theme()
  end
end, {
  nargs = "?",
  complete = function(arglead)
    local matches = {}
    for _, t in ipairs(themes) do
      if t.id:find(arglead, 1, true) then
        table.insert(matches, t.id)
      end
    end
    return matches
  end,
  desc = "Select or switch colorscheme",
})

-- 3. Core Editor Options
local opt = vim.opt

-- Line numbers (colored directly by Git diff and Diagnostics; no extra sign column)
opt.number = true
opt.relativenumber = true

-- Cursor & Visuals
opt.cursorline = true
opt.signcolumn = "no"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

-- Indentation (4 spaces default for C / Algorithms / Uni projects)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Splits & Undo
opt.splitright = true
opt.splitbelow = true
opt.undofile = true       -- Persistent undo across nvim restarts
opt.swapfile = false
opt.autoread = true       -- Silently reload files changed outside Neovim (git, build tools)
opt.modeline = false      -- Disable modelines (prevents false E518 syntax errors in STM32 / vendor comments)
opt.updatetime = 250

-- Generous timeout for key sequences (prevents Leader expiring into insert mode)
opt.timeoutlen = 3000

-- Completion settings: standard options to prevent premature closing
opt.completeopt = { "menu", "menuone", "noselect" }

-- Seamless Statusline: blends 100% into editor background without cursor jumping
opt.laststatus = 3
opt.showmode = false
opt.ruler = false
opt.showcmd = false
opt.fillchars = { stl = " ", stlnc = " " }
opt.statusline = "%!v:lua.get_mode_statusline()"

-- Clipboard (Wayland / X11 via wl-copy / xclip)
opt.clipboard = "unnamedplus"

-- Makefiles require hard tabs (crucial for Operating Systems / Makefiles)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
  end,
})

-- Bundled Tree-sitter for C / C++ / Lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "lua" },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Passive: Automatically check for external file changes when gaining focus
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  desc = "Reload buffer if changed externally",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Passive: Restore cursor to last known position upon opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore last cursor position",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Passive: Automatically create missing parent directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto-create missing parent directories",
  callback = function(args)
    if args.match:match("^%a%a+:[\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fs.dirname(file), "p")
  end,
})

-- 4. Terminal Toggle (<Ctrl>+/)
-- Opens at bottom if viewport is taller than wider; on the right side otherwise
-- Preserves and restores exact cursor position on exit
local term_buf = nil
local term_win = nil
local prev_win = nil
local prev_cursor = nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.cmd("stopinsert")
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    if prev_win and vim.api.nvim_win_is_valid(prev_win) then
      vim.api.nvim_set_current_win(prev_win)
      if prev_cursor then
        pcall(vim.api.nvim_win_set_cursor, prev_win, prev_cursor)
      end
    end
    return
  end

  -- Save current window and cursor position before opening
  prev_win = vim.api.nvim_get_current_win()
  prev_cursor = vim.api.nvim_win_get_cursor(prev_win)

  -- Detect screen aspect ratio (character cell height is ~2x cell width visually)
  local is_taller = (vim.o.lines * 2) > vim.o.columns
  if is_taller then
    vim.cmd("botright 14split")
  else
    local width = math.floor(vim.o.columns * 0.42)
    vim.cmd("botright " .. width .. "vsplit")
  end
  term_win = vim.api.nvim_get_current_win()

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    vim.cmd.terminal()
    term_buf = vim.api.nvim_get_current_buf()
    vim.bo[term_buf].buflisted = false
  end
  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminal, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_terminal, { desc = "Toggle Terminal" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode to normal" })

-- Restore cursor if terminal job terminates directly (e.g. typing exit)
vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    if args.buf == term_buf then
      vim.cmd("stopinsert")
      if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_hide(term_win)
        term_win = nil
      end
      term_buf = nil
      if prev_win and vim.api.nvim_win_is_valid(prev_win) then
        vim.api.nvim_set_current_win(prev_win)
        if prev_cursor then
          pcall(vim.api.nvim_win_set_cursor, prev_win, prev_cursor)
        end
      end
    end
  end,
})

-- 5. Lazygit Floating Window (<leader>gg)
local lazygit_win = nil
local lazygit_buf = nil

local function toggle_lazygit()
  if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
    vim.api.nvim_win_close(lazygit_win, true)
    lazygit_win = nil
    return
  end

  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("lazygit not found", vim.log.levels.ERROR)
    return
  end

  local width = math.floor(vim.o.columns * 0.90)
  local height = math.floor(vim.o.lines * 0.88)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  lazygit_buf = vim.api.nvim_create_buf(false, true)
  lazygit_win = vim.api.nvim_open_win(lazygit_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    border = "rounded",
    title = " Lazygit ",
    title_pos = "center",
    style = "minimal",
  })

  vim.bo[lazygit_buf].buflisted = false

  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_file = vim.api.nvim_buf_get_name(cur_buf)
  local start_dir = (cur_file ~= "" and vim.fs.root(cur_file, ".git"))
    or vim.fs.root(0, ".git")
    or vim.fn.getcwd()

  vim.fn.jobstart({ "lazygit" }, {
    cwd = start_dir,
    term = true,
    on_exit = function()
      if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
        vim.api.nvim_win_close(lazygit_win, true)
      end
      lazygit_win = nil
      if lazygit_buf and vim.api.nvim_buf_is_valid(lazygit_buf) then
        vim.api.nvim_buf_delete(lazygit_buf, { force = true })
      end
      lazygit_buf = nil
      vim.cmd("checktime")
    end,
  })

  vim.keymap.set("n", "q", function()
    if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
      vim.api.nvim_win_close(lazygit_win, true)
      lazygit_win = nil
    end
  end, { buffer = lazygit_buf, silent = true })

  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>gg", toggle_lazygit, { desc = "Lazygit" })

-- 6. Smart C / C++ Build & Run Runner (<leader>r)
-- Detects CMake (cmake -B build && cmake --build build --parallel),
-- nob (Tsoding's nob.c), and Makefiles (make -j$(nproc)),
-- or compiles standalone single-file C/C++ with gcc/g++.
local runner_buf = nil
local runner_win = nil
local runner_job = nil

local function run_c_project()
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_file = vim.api.nvim_buf_get_name(cur_buf)
  if cur_file ~= "" and vim.bo[cur_buf].modified then
    vim.cmd("silent! write")
  end

  local start_dir = (cur_file ~= "" and vim.fs.dirname(cur_file)) or vim.fn.getcwd()
  local ext = cur_file ~= "" and vim.fn.fnamemodify(cur_file, ":e"):lower() or ""
  local filename = cur_file ~= "" and vim.fn.fnamemodify(cur_file, ":t:r") or "main"

  local cmake_root = vim.fs.root(start_dir, "CMakeLists.txt")
  local nob_root   = vim.fs.root(start_dir, { "nob.c", "nob" })
  local make_root  = vim.fs.root(start_dir, { "Makefile", "makefile", "GNUmakefile" })

  local cwd = start_dir
  local run_cmd = nil
  local mode_desc = nil

  if cmake_root then
    cwd = cmake_root
    local cm_path = cmake_root .. "/CMakeLists.txt"
    local f = io.open(cm_path, "r")
    local content = f and f:read("*a") or ""
    if f then f:close() end
    local target = content:match("add_executable%s*%([ \t\r\n]*([%w_%-]+)")
    if target then
      run_cmd = string.format([[cmake -B build && cmake --build build --parallel && ([ -x "build/%s" ] && ./build/%s || [ -x "build/bin/%s" ] && ./build/bin/%s || $(find build -name "%s" -type f -executable 2>/dev/null | head -n 1))]], target, target, target, target, target)
      mode_desc = "CMake: " .. target
    else
      run_cmd = [[cmake -B build && cmake --build build --parallel && $(find build -maxdepth 2 -type f -executable ! -name "*.so" ! -name "CMake*" 2>/dev/null | head -n 1)]]
      mode_desc = "CMake"
    end
  elseif nob_root then
    cwd = nob_root
    local nob_c_path = nob_root .. "/nob.c"
    local f = io.open(nob_c_path, "r")
    local content = f and f:read("*a") or ""
    if f then f:close() end
    local exe = content:match("%-o%s+([%w_%-]+)") or vim.fs.basename(nob_root)
    local has_run = content:find('"run"') or content:find("'run'")
    local has_build = content:find('"build"') or content:find("'build'")

    if has_run then
      run_cmd = "([ -f ./nob ] || ${CC:-cc} -O2 -o nob nob.c) && ./nob run"
    elseif has_build then
      run_cmd = string.format([[([ -f ./nob ] || ${CC:-cc} -O2 -o nob nob.c) && ./nob build && ([ -x "./%s" ] && ./%s || $(find . -maxdepth 2 -type f -executable ! -name "nob*" 2>/dev/null | head -n 1))]], exe, exe)
    else
      run_cmd = string.format([[([ -f ./nob ] || ${CC:-cc} -O2 -o nob nob.c) && ./nob && ([ -x "./%s" ] && ./%s || $(find . -maxdepth 2 -type f -executable ! -name "nob*" 2>/dev/null | head -n 1))]], exe, exe)
    end
    mode_desc = "nob: " .. exe
  elseif make_root then
    cwd = make_root
    local make_path = make_root .. "/Makefile"
    if not vim.uv.fs_stat(make_path) then make_path = make_root .. "/makefile" end
    local f = io.open(make_path, "r")
    local content = f and f:read("*a") or ""
    if f then f:close() end
    local has_run = content:match("\nrun%s*:") or content:match("^run%s*:")
    if has_run then
      run_cmd = "make -j$(nproc) && make run"
      mode_desc = "Makefile: run"
    else
      local first_target = content:match("\n([%w_%-]+)%s*:") or content:match("^([%w_%-]+)%s*:")
      if first_target and first_target ~= "all" and first_target ~= "clean" then
        run_cmd = string.format([[make -j$(nproc) && ([ -x "./%s" ] && ./%s || $(find . -maxdepth 2 -type f -executable ! -name "*.so" ! -name ".*" 2>/dev/null | head -n 1))]], first_target, first_target)
        mode_desc = "Makefile: " .. first_target
      else
        run_cmd = [[make -j$(nproc) && $(find . -maxdepth 2 -type f -executable ! -name "*.so" ! -name ".*" 2>/dev/null | head -n 1)]]
        mode_desc = "Makefile"
      end
    end
  elseif ext == "c" or ext == "h" then
    local out_bin = "/tmp/" .. filename
    run_cmd = string.format([[gcc -Wall -Wextra -O2 -g %q -o %q -lm && %q]], cur_file, out_bin, out_bin)
    mode_desc = "gcc: " .. filename
  elseif ext == "cpp" or ext == "cc" or ext == "cxx" or ext == "hpp" then
    local out_bin = "/tmp/" .. filename
    run_cmd = string.format([[g++ -std=c++20 -Wall -Wextra -O2 -g %q -o %q -lm && %q]], cur_file, out_bin, out_bin)
    mode_desc = "g++: " .. filename
  else
    vim.notify("No CMake, nob, Makefile, or C/C++ source detected", vim.log.levels.WARN)
    return
  end

  if runner_job then
    pcall(vim.fn.jobstop, runner_job)
    runner_job = nil
  end

  if runner_win and vim.api.nvim_win_is_valid(runner_win) then
    vim.api.nvim_win_close(runner_win, true)
    runner_win = nil
  end

  local height = math.min(16, math.max(10, math.floor(vim.o.lines * 0.35)))
  vim.cmd("botright " .. height .. "split")
  runner_win = vim.api.nvim_get_current_win()

  runner_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(runner_win, runner_buf)
  vim.bo[runner_buf].buflisted = false
  vim.bo[runner_buf].bufhidden = "wipe"

  vim.keymap.set("n", "q", function()
    if runner_win and vim.api.nvim_win_is_valid(runner_win) then
      vim.api.nvim_win_close(runner_win, true)
    end
    runner_win = nil
  end, { buffer = runner_buf, silent = true })

  local full_cmd = {
    "bash",
    "-c",
    string.format([[echo -e "\027[1;36m==> [%s]\027[0m \027[0;90m%s\027[0m\n"; %s]],
      mode_desc,
      run_cmd:gsub('"', '\\"'),
      run_cmd
    ),
  }

  runner_job = vim.fn.jobstart(full_cmd, {
    term = true,
    cwd = cwd,
    on_exit = function()
      runner_job = nil
    end,
  })

  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>r", run_c_project, { desc = "Build & run" })

-- 6. Visual Mode Auto-Wrap
-- In visual mode, press (, [, {, ", ', `, or $ to wrap the selected text
local function visual_wrap(left, right)
  local mode = vim.fn.mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  local s_pos = vim.api.nvim_buf_get_mark(0, "<")
  local e_pos = vim.api.nvim_buf_get_mark(0, ">")
  local s_row, s_col = s_pos[1] - 1, s_pos[2]
  local e_row, e_col = e_pos[1] - 1, e_pos[2]

  local end_line = vim.api.nvim_buf_get_lines(0, e_row, e_row + 1, false)[1] or ""
  if mode == "V" then
    s_col = 0
    e_col = #end_line
  else
    local add = (e_col < #end_line) and (vim.str_utf_end(end_line, e_col + 1) + 1) or 1
    e_col = math.min(e_col + add, #end_line)
  end

  local lines = vim.api.nvim_buf_get_text(0, s_row, s_col, e_row, e_col, {})
  if #lines == 0 then return end
  if #lines == 1 then
    vim.api.nvim_buf_set_text(0, s_row, s_col, e_row, e_col, { left .. lines[1] .. right })
  else
    lines[1] = left .. lines[1]
    lines[#lines] = lines[#lines] .. right
    vim.api.nvim_buf_set_text(0, s_row, s_col, e_row, e_col, lines)
  end
end

local pairs_to_wrap = {
  ["("] = { "(", ")" },
  [")"] = { "(", ")" },
  ["["] = { "[", "]" },
  ["]"] = { "[", "]" },
  ["{"] = { "{", "}" },
  ["}"] = { "{", "}" },
  ['"'] = { '"', '"' },
  ["'"] = { "'", "'" },
  ["`"] = { "`", "`" },
  ["$"] = { "$", "$" },
  ["*"] = { "*", "*" },
}

for key, p in pairs(pairs_to_wrap) do
  vim.keymap.set("x", key, function()
    visual_wrap(p[1], p[2])
  end, { desc = "Wrap selection in " .. p[1] .. p[2] })
end

-- 6. Clipboard Ring Buffer (Synchronized with cliphist)
-- 'p' / 'P' pastes from ring; immediately after pasting, cycle with:
--   '[p' / '[y' / '<C-p>' (older)
--   ']p' / ']y' / '<C-n>' (newer)
-- '<leader>p' opens mini.pick clipboard history picker
local clip_items = {}
local clip_local_ring = {}
local clip_idx = 1
local clip_active = false
local clip_in_progress = false
local clip_bufnr = nil
local clip_last_cmd = "p"
local clip_expected_cursor = nil
local clip_paste_tick = nil
local clip_augroup = nil

local clip_cleanup

local function get_cliphist_items(max)
  max = max or 50
  if vim.fn.executable("cliphist") ~= 1 then return {} end
  local out = vim.fn.system({ "cliphist", "list" })
  if vim.v.shell_error ~= 0 or not out or out == "" then return {} end

  local list = {}
  for line in out:gmatch("[^\r\n]+") do
    local id, preview = line:match("^(%d+)\t(.*)$")
    if id and preview and not preview:match("^%[%[%s*binary%s+data") then
      table.insert(list, { id = id, preview = preview, text = nil, regtype = nil })
      if #list >= max then break end
    end
  end
  return list
end

local function get_item_text(item)
  if item.text then return item.text, item.regtype end
  local text = ""
  if item.id then
    text = vim.fn.system({ "cliphist", "decode", item.id })
  else
    text = item.preview or ""
  end
  local regtype = "c"
  if text:find("\n") and text:sub(-1) == "\n" then
    regtype = "V"
  end
  item.text = text
  item.regtype = regtype
  return text, regtype
end

local function load_all_clips()
  local items = get_cliphist_items(50)
  if #items == 0 then
    -- Fallback to local in-memory ring if cliphist is empty/unavailable
    items = vim.deepcopy(clip_local_ring)
  end

  local ok, current_clip = pcall(vim.fn.getreg, "+")
  if ok and current_clip and current_clip ~= "" and not current_clip:match("^%s*$") then
    local top_text = (#items > 0) and get_item_text(items[1]) or ""
    if top_text ~= current_clip then
      local regtype = vim.fn.getregtype("+") or "c"
      local preview = current_clip:gsub("\n.*$", "")
      table.insert(items, 1, {
        id = nil,
        preview = preview,
        text = current_clip,
        regtype = regtype,
      })
    end
  end
  return items
end

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local event = vim.v.event
    if not event or not event.regcontents then return end
    local text = table.concat(event.regcontents, "\n")
    if text == "" or text:match("^%s*$") then return end
    local is_yank = event.operator == "y"
    local is_substantive_del = (event.operator == "d") and (#event.regcontents > 1 or #(event.regcontents[1] or "") > 3)
    if is_yank or is_substantive_del then
      table.insert(clip_local_ring, 1, {
        id = nil,
        preview = event.regcontents[1] or "",
        text = text,
        regtype = event.regtype or "c",
      })
      if #clip_local_ring > 50 then table.remove(clip_local_ring) end
    end
    if is_yank then
      pcall(vim.hl.on_yank, { higroup = "Visual", timeout = 150 })
    end
  end,
})

clip_cleanup = function()
  if not clip_active or clip_in_progress then return end
  clip_active = false
  if clip_augroup then
    pcall(vim.api.nvim_del_augroup_by_id, clip_augroup)
    clip_augroup = nil
  end
  vim.cmd("echo ''")
end

local function setup_cycle_autocmds()
  if clip_augroup then pcall(vim.api.nvim_del_augroup_by_id, clip_augroup) end
  clip_augroup = vim.api.nvim_create_augroup("ClipCycling", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave", "WinLeave" }, {
    group = clip_augroup,
    callback = clip_cleanup,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = clip_augroup,
    pattern = "*:[!n]*",
    callback = clip_cleanup,
  })

  vim.api.nvim_create_autocmd("TextChanged", {
    group = clip_augroup,
    callback = function()
      if clip_in_progress or not clip_active then return end
      local tick = vim.api.nvim_buf_get_changedtick(clip_bufnr or 0)
      if tick == clip_paste_tick then return end
      clip_cleanup()
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = clip_augroup,
    callback = function()
      if clip_in_progress or not clip_active then return end
      local cur = vim.api.nvim_win_get_cursor(0)
      if clip_expected_cursor and cur[1] == clip_expected_cursor[1] and cur[2] == clip_expected_cursor[2] then
        return
      end
      clip_cleanup()
    end,
  })
end

local function paste_at_index(idx, cmd)
  local item = clip_items[idx]
  if not item then return end

  clip_in_progress = true
  local text, regtype = get_item_text(item)
  vim.fn.setreg('"', text, regtype)
  vim.fn.setreg("+", text, regtype)

  if clip_active then
    local ok = pcall(vim.cmd, "silent! undo")
    if not ok then
      clip_cleanup()
      clip_in_progress = false
      return
    end
    vim.cmd("normal! " .. clip_last_cmd)
  else
    clip_bufnr = vim.api.nvim_get_current_buf()
    clip_last_cmd = cmd
    clip_active = true
    vim.cmd("normal! " .. cmd)
    setup_cycle_autocmds()
  end

  clip_expected_cursor = vim.api.nvim_win_get_cursor(0)
  clip_paste_tick = vim.api.nvim_buf_get_changedtick(clip_bufnr)
  clip_idx = idx
  clip_in_progress = false

  local preview = item.preview or text:gsub("\n.*$", "")
  if #preview > 35 then preview = preview:sub(1, 32) .. "..." end
  local msg = string.format("clip [%d/%d] %s  ([p]/<C-p> older  ]p/<C-n> newer  <Esc> done)", clip_idx, #clip_items, preview)
  vim.api.nvim_echo({ { msg, "ModeMsg" } }, false, {})
end

local function paste_ring(cmd)
  if not vim.bo.modifiable or vim.bo.readonly then
    vim.cmd("normal! " .. cmd)
    return
  end
  clip_cleanup()
  clip_items = load_all_clips()
  if #clip_items == 0 then
    vim.cmd("normal! " .. cmd)
    return
  end
  paste_at_index(1, cmd)
end

local function cycle_clip(step)
  if #clip_items == 0 then
    clip_items = load_all_clips()
  end
  if #clip_items == 0 then return end

  if not clip_active then
    -- If not currently cycling, [p pastes the 2nd most recent clip (older) or 1st
    local target = (step > 0) and 2 or 1
    if target > #clip_items then target = 1 end
    paste_at_index(target, "p")
    return
  end

  if #clip_items <= 1 then return end
  local next_idx = clip_idx + step
  if next_idx > #clip_items then next_idx = 1 end
  if next_idx < 1 then next_idx = #clip_items end
  paste_at_index(next_idx, clip_last_cmd)
end

vim.keymap.set("n", "p", function() paste_ring("p") end, { desc = "Paste from clipboard ring" })
vim.keymap.set("n", "P", function() paste_ring("P") end, { desc = "Paste before from clipboard ring" })
vim.keymap.set("n", "[p", function() cycle_clip(1) end, { desc = "Previous (older) clipboard entry" })
vim.keymap.set("n", "]p", function() cycle_clip(-1) end, { desc = "Next (newer) clipboard entry" })
vim.keymap.set("n", "[y", function() cycle_clip(1) end, { desc = "Previous (older) clipboard entry" })
vim.keymap.set("n", "]y", function() cycle_clip(-1) end, { desc = "Next (newer) clipboard entry" })

vim.keymap.set("n", "<C-p>", function()
  if clip_active then
    cycle_clip(1)
  else
    vim.cmd("normal! <C-p>")
  end
end, { desc = "Previous (older) clipboard entry when cycling" })

vim.keymap.set("n", "<C-n>", function()
  if clip_active then
    cycle_clip(-1)
  else
    vim.cmd("normal! <C-n>")
  end
end, { desc = "Next (newer) clipboard entry when cycling" })

vim.keymap.set("n", "<Esc>", function()
  if clip_active then
    clip_cleanup()
  else
    vim.cmd("nohlsearch")
  end
end, { desc = "Clear search highlight / dismiss clip cycle" })

local function pick_clipboard_ring()
  clip_cleanup()
  local items = load_all_clips()
  if #items == 0 then
    vim.notify("clipboard is empty", vim.log.levels.INFO)
    return
  end

  local pick_items = {}
  for i, it in ipairs(items) do
    table.insert(pick_items, {
      text = string.format("%2d. %s", i, it.preview),
      item = it,
      idx = i,
    })
  end

  require("mini.pick").start({
    source = {
      items = pick_items,
      name = "Clipboard Ring (cliphist)",
      choose = function(selected)
        if not selected then return end
        clip_items = items
        paste_at_index(selected.idx, "p")
      end,
    },
  })
end

vim.keymap.set("n", "<leader>p", pick_clipboard_ring, { desc = "Clipboard ring" })

-- 7. Plugin Manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Autosuggestion State:
-- 1 = Ghost text only (grayed-out inline suggestion, accept via Tab)
-- 2 = Popup menu (dropdown list with docs)
-- 3 = None (suggestions disabled)
local autosuggest_mode = 1

require("lazy").setup({
  -- Themes & Colorschemes
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },

  -- File manager: Oil (mapped to -)
  {
    "stevearc/oil.nvim",
    lazy = false,
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = { show_hidden = true },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  -- File & Grep picker: mini.pick (works in git repos and non-git directories)
  {
    "echasnovski/mini.pick",
    version = false,
    lazy = false,
    config = function()
      require("mini.pick").setup()

      -- <leader>ff: Find files (works in git repo or standard directory)
      vim.keymap.set("n", "<leader>ff", function()
        local cwd = vim.fn.getcwd()
        local git_root = vim.fs.root(cwd, ".git")
        local has_rg = vim.fn.executable("rg") == 1

        if has_rg then
          local root = git_root or cwd
          require("mini.pick").builtin.files({ tool = "rg" }, { source = { cwd = root, name = "Files" } })
        elseif git_root then
          require("mini.pick").builtin.files({ tool = "git" }, { source = { cwd = git_root, name = "Files" } })
        else
          local cmd = { "find", ".", "-maxdepth", "5", "-not", "-path", "*/.*", "-type", "f" }
          require("mini.pick").builtin.cli(
            {
              command = cmd,
              postprocess = function(item)
                return item:gsub("^%./", "")
              end,
            },
            { source = { cwd = cwd, name = "Files" } }
          )
        end
      end, { desc = "Find file" })

      -- <leader>fg: Grep in scope (works in git repo or standard directory)
      vim.keymap.set("n", "<leader>fg", function()
        local cwd = vim.fn.getcwd()
        local git_root = vim.fs.root(cwd, ".git")
        local has_rg = vim.fn.executable("rg") == 1

        if has_rg then
          local root = git_root or cwd
          require("mini.pick").builtin.grep_live({ tool = "rg" }, { source = { cwd = root, name = "Grep" } })
        elseif git_root then
          require("mini.pick").builtin.grep_live({ tool = "git" }, { source = { cwd = git_root, name = "Grep" } })
        else
          vim.ui.input({ prompt = "Grep: " }, function(pattern)
            if not pattern or pattern == "" then return end
            local cmd = { "grep", "-rnI", "--exclude-dir=.git", pattern, "." }
            require("mini.pick").builtin.cli(
              {
                command = cmd,
                postprocess = function(item)
                  return item:gsub("^%./", "")
                end,
              },
              { source = { cwd = cwd, name = "Grep: " .. pattern } }
            )
          end)
        end
      end, { desc = "Live grep" })
    end,
  },

  -- Leader Key Hints: mini.clue (shows bottom popup hints when pressing Leader)
  {
    "echasnovski/mini.clue",
    version = false,
    lazy = false,
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
        },
        clues = {
          { mode = "n", keys = "<Leader>r",        desc = "build & run" },
          { mode = "n", keys = "<Leader>a",        desc = "cycle autosuggest" },
          { mode = "n", keys = "<Leader>l",        desc = "toggle light/dark" },
          { mode = "n", keys = "<Leader>th",       desc = "select theme" },
          { mode = "n", keys = "<Leader>ff",       desc = "find file" },
          { mode = "n", keys = "<Leader>fg",       desc = "live grep" },
          { mode = "n", keys = "<Leader>g",        desc = "+git/goto" },
          { mode = "n", keys = "<Leader>gd",       desc = "goto definition (.c/.h)" },
          { mode = "n", keys = "<Leader>gg",       desc = "lazygit" },
          { mode = "n", keys = "<Leader>p",        desc = "clipboard ring" },
          { mode = "n", keys = "<Leader>c",        desc = "+code" },
          { mode = "n", keys = "<Leader>ca",       desc = "code action" },
          { mode = "n", keys = "<Leader>cr",       desc = "rename symbol" },
          { mode = "n", keys = "<Leader>cf",       desc = "format buffer" },
          { mode = "n", keys = "<Leader>d",        desc = "diagnostic float" },
          { mode = "n", keys = "<Leader>q",        desc = "buffer errors" },
          { mode = "n", keys = "<Leader>F",        desc = "toggle autoformat" },
          { mode = "n", keys = "<Leader><Leader>", desc = "alternate buffer" },
        },
        window = {
          delay = 100,
          config = {
            anchor = "SE",
            row = "auto",
            col = "auto",
            width = "auto",
          },
        },
      })
    end,
  },

  -- Auto-closing pairs: mini.pairs
  {
    "echasnovski/mini.pairs",
    version = false,
    lazy = false,
    config = function()
      require("mini.pairs").setup()
    end,
  },

  -- Git Diff: mini.diff (colors line numbers by line status without extra column)
  {
    "echasnovski/mini.diff",
    version = false,
    lazy = false,
    config = function()
      require("mini.diff").setup({
        view = {
          style = "number",
          priority = 50,
        },
      })
    end,
  },

  -- Passive textobjects: mini.ai (smart brackets, function arguments cia/dia, functions cif/daf)
  {
    "echasnovski/mini.ai",
    version = false,
    lazy = false,
    opts = {
      n_lines = 500,
    },
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },

  -- Sticky scope headers: nvim-treesitter-context (pins function/struct header when scrolling)
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 20,
      mode = "cursor",
      separator = nil,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    lazy = false,
    opts = {
      bind = true,
      floating_window = true,
      floating_window_above_cur_line = true,
      hint_enable = false, -- Clean floating popup without inline virtual text clutter
      handler_opts = { border = "rounded" },
      hi_parameter = "LspSignatureActiveParameter",
      always_trigger = true,
      extra_trigger_chars = { "(", "," },
      toggle_key = "<C-k>",
      timer_interval = 100,
      check_completion_visible = true,
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },

  -- Autocompletion engine
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")

      local cmp_formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
          local ci = entry:get_completion_item()
          if ci.labelDetails and ci.labelDetails.detail then
            vim_item.abbr = vim_item.abbr .. ci.labelDetails.detail
          elseif ci.detail and ci.detail:match("^%s*%(") then
            vim_item.abbr = vim_item.abbr .. ci.detail
          end
          if ci.labelDetails and ci.labelDetails.description then
            vim_item.menu = ci.labelDetails.description
          elseif ci.detail then
            vim_item.menu = ci.detail
          end
          return vim_item
        end,
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }),
        formatting = cmp_formatting,
        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged },
          completeopt = "menu,menuone,noselect",
        },
        view = {
          docs = { auto_open = false },
        },
        window = {
          completion = {
            border = "none",
            scrollbar = false,
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Normal,Search:None",
          },
          documentation = cmp.config.disable,
        },
        experimental = {
          ghost_text = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and autosuggest_mode == 2 then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if autosuggest_mode == 1 then
                -- Mode 1 (Ghost text): Tab accepts the suggestion immediately
                cmp.confirm({ select = true })
              else
                -- Mode 2 (Popup menu): Tab navigates to next item
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              end
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })

      -- Intercept popup windows to ensure Mode 1 has NO scrollbars and NO docs window
      if cmp.core and cmp.core.view then
        local custom_view = cmp.core.view.custom_entries_view
        if custom_view and custom_view.entries_win then
          local orig_open = custom_view.entries_win.open
          custom_view.entries_win.open = function(self, opts)
            local res = orig_open(self, opts)
            if autosuggest_mode == 1 then
              if self.win and vim.api.nvim_win_is_valid(self.win) then
                pcall(vim.api.nvim_win_set_config, self.win, { hide = true })
              end
              if self.scrollbar_win and self.scrollbar_win.win and vim.api.nvim_win_is_valid(self.scrollbar_win.win) then
                pcall(vim.api.nvim_win_set_config, self.scrollbar_win.win, { hide = true })
              end
            end
            return res
          end
        end

        local docs_view = cmp.core.view.docs_view
        if docs_view then
          local orig_docs_open = docs_view.open
          docs_view.open = function(self, ...)
            if autosuggest_mode == 1 then
              return self:close()
            end
            return orig_docs_open(self, ...)
          end
        end
      end
    end,
  },
}, {
  defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- Apply active theme once plugins are initialized
apply_theme(current_theme_id, false)

-- 7. 3-Way Autosuggestion Toggle (<leader>a)
local mode_labels = {
  [1] = "ghost text",
  [2] = "popup menu",
  [3] = "off",
}

local function set_autosuggest_mode(new_mode)
  autosuggest_mode = new_mode
  local cmp = require("cmp")

  if autosuggest_mode == 1 then
    cmp.setup({
      completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        completeopt = "menu,menuone,noselect",
      },
      view = {
        docs = { auto_open = false },
      },
      window = {
        completion = {
          border = "none",
          scrollbar = false,
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Normal,Search:None",
        },
        documentation = cmp.config.disable,
      },
      experimental = { ghost_text = true },
    })
  elseif autosuggest_mode == 2 then
    local doc_window = cmp.config.window.bordered()
    doc_window.max_width = math.floor(vim.o.columns * 0.45)
    doc_window.max_height = 20

    cmp.setup({
      completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        completeopt = "menu,menuone,noselect",
      },
      view = {
        docs = { auto_open = true },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = doc_window,
      },
      experimental = { ghost_text = false },
    })
  else -- mode 3: off
    cmp.setup({
      completion = { autocomplete = false },
      experimental = { ghost_text = false },
    })
    cmp.close()
  end

  vim.notify(mode_labels[autosuggest_mode], vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>a", function()
  local next_mode = (autosuggest_mode % 3) + 1
  set_autosuggest_mode(next_mode)
end, { desc = "Cycle autosuggest" })

-- 8. Clangd LSP Configuration (Built-in Neovim 0.12 LSP Client)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config["clangd"] = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=none",
    "--query-driver=/usr/bin/arm-none-eabi-*,/usr/bin/gcc*,/usr/bin/g*,/usr/bin/clang*,/usr/local/bin/arm-none-eabi-*",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  capabilities = capabilities,
  root_markers = { ".clangd", ".clang-format", "compile_commands.json", "compile_flags.txt", "Makefile", ".git" },
}
vim.lsp.enable("clangd")

-- Check if a .clang-format file exists within the current repository / project
local function has_repo_clang_format(bufnr)
  bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    return false
  end

  local dir = vim.fs.dirname(filepath)
  local home = vim.env.HOME or "/home/nihil"

  -- Locate the repository or project root
  local repo_root = vim.fs.root(filepath, {
    ".git",
    "compile_commands.json",
    "compile_flags.txt",
    "CMakeLists.txt",
    "Makefile",
    "nob.c",
    "nob",
  })

  local stop_dir = repo_root and vim.fs.dirname(repo_root) or home

  local found = vim.fs.find({ ".clang-format", "_clang-format" }, {
    upward = true,
    path = dir,
    stop = stop_dir,
  })

  if #found > 0 then
    local cf_path = found[1]
    -- Ignore global ~/.clang-format
    if cf_path == home .. "/.clang-format" or cf_path == home .. "/_clang-format" then
      return false
    end
    -- If inside a repository, ensure .clang-format is within that repository
    if repo_root and not vim.startswith(cf_path, repo_root) then
      return false
    end
    return true
  end

  return false
end

-- Smart Go to Definition (<leader>gd and gd):
-- 1. If on a usage/call site -> jumps to the definition.
-- 2. If already on the definition in .c/.cpp -> jumps to the declaration in .h/.hpp.
-- 3. If on the declaration in .h/.hpp -> jumps to the definition in .c/.cpp.
-- 4. If cursor is on return type / parens of a function line -> resolves that function's counterpart.
-- 5. Fallback if clangd hasn't indexed counterpart file yet -> switches .c <-> .h and jumps to the symbol.
local function smart_goto_definition()
  local bufnr = vim.api.nvim_get_current_buf()
  local cur_file = vim.api.nvim_buf_get_name(bufnr)
  local cur_real = (cur_file ~= "" and vim.uv.fs_realpath(cur_file)) or cur_file
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cur_line = cursor[1]
  local cur_col = cursor[2]
  local cword = vim.fn.expand("<cword>")
  local line_str = vim.api.nvim_get_current_line()

  local line_func = line_str:match("([%a_][%w_]*)%s*%(")
  local target_sym = (cword ~= "" and cword:match("^[%a_][%w_]*$")) and cword or line_func

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local client = clients[1]
  local encoding = (client and client.offset_encoding) or "utf-16"

  local function extract_locations(result)
    if not result then return {} end
    local list = vim.islist(result) and result or { result }
    local locs = {}
    for _, item in ipairs(list) do
      local uri = item.targetUri or item.uri
      local range = item.targetSelectionRange or item.targetRange or item.range
      if uri and range then
        local fpath = vim.uri_to_fname(uri)
        local rpath = vim.uv.fs_realpath(fpath) or fpath
        table.insert(locs, {
          uri = uri,
          path = fpath,
          realpath = rpath,
          line = range.start.line + 1,
          col = range.start.character,
          raw = item,
        })
      end
    end
    return locs
  end

  local function pick_other_location(locs)
    for _, loc in ipairs(locs) do
      if loc.realpath ~= cur_real then
        return loc
      end
    end
    for _, loc in ipairs(locs) do
      if loc.line ~= cur_line then
        return loc
      end
    end
    return nil
  end

  local function jump_to_loc(loc)
    vim.cmd("normal! m'")
    vim.lsp.util.show_document(loc.raw, encoding, { focus = true })
  end

  local function fallback_switch_header_and_find(sym)
    local function open_and_search(target_path)
      if not target_path or target_path == "" then return false end
      local target_real = vim.uv.fs_realpath(target_path) or target_path
      if target_real == cur_real then return false end
      if vim.fn.filereadable(target_path) ~= 1 then return false end

      vim.cmd("normal! m'")
      vim.cmd("edit " .. vim.fn.fnameescape(target_path))
      if sym and sym ~= "" then
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local best_line, best_col = nil, 0
        for i, l in ipairs(lines) do
          local s = l:find("%f[%w_]" .. vim.pesc(sym) .. "%s*%(")
          if s then
            best_line, best_col = i, s - 1
            break
          elseif not best_line then
            local w = l:find("%f[%w_]" .. vim.pesc(sym) .. "%f[^%w_]")
            if w then
              best_line, best_col = i, w - 1
            end
          end
        end
        if best_line then
          pcall(vim.api.nvim_win_set_cursor, 0, { best_line, best_col })
        end
      end
      return true
    end

    local function search_by_filename()
      local ext = cur_file:match("^.+%.([^.]+)$")
      local stem = vim.fn.fnamemodify(cur_file, ":t:r")
      if not ext or not stem then return end
      local target_exts = {}
      if ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx" then
        target_exts = { "h", "hpp", "hh" }
      elseif ext == "h" or ext == "hpp" or ext == "hh" then
        target_exts = { "c", "cpp", "cc", "cxx" }
      end
      if #target_exts == 0 then return end

      local root = vim.fs.root(cur_file, { ".git", "compile_commands.json", "CMakeLists.txt", "Makefile", "nob.c" }) or vim.fs.dirname(cur_file)
      local names = {}
      for _, te in ipairs(target_exts) do
        table.insert(names, stem .. "." .. te)
      end
      local found = vim.fs.find(names, { path = root, type = "file", limit = 5 })
      for _, f in ipairs(found) do
        if open_and_search(f) then
          return
        end
      end
    end

    if client then
      client:request("textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(bufnr) }, function(err, switched_uri)
        if not err and switched_uri and switched_uri ~= "" then
          if open_and_search(vim.uri_to_fname(switched_uri)) then
            return
          end
        end
        search_by_filename()
      end, bufnr)
    else
      search_by_filename()
    end
  end

  if not client then
    fallback_switch_header_and_find(line_func or target_sym)
    return
  end

  local function query_at_position(pos_params, allow_line_func_retry)
    client:request("textDocument/definition", pos_params, function(_, def_res)
      local def_locs = extract_locations(def_res)
      local target = pick_other_location(def_locs)
      if target then
        jump_to_loc(target)
        return
      end

      client:request("textDocument/declaration", pos_params, function(_, decl_res)
        local decl_locs = extract_locations(decl_res)
        local decl_target = pick_other_location(decl_locs)
        if decl_target then
          jump_to_loc(decl_target)
          return
        end

        if allow_line_func_retry and line_func then
          local func_s = line_str:find("%f[%w_]" .. vim.pesc(line_func) .. "%s*%(")
          if func_s and (func_s - 1) ~= cur_col then
            local retry_params = vim.lsp.util.make_position_params(0, encoding)
            retry_params.position.character = func_s - 1
            query_at_position(retry_params, false)
            return
          end
        end

        fallback_switch_header_and_find(line_func or target_sym)
      end, bufnr)
    end, bufnr)
  end

  local params = vim.lsp.util.make_position_params(0, encoding)
  query_at_position(params, true)
end

vim.keymap.set("n", "<leader>gd", smart_goto_definition, { desc = "Go to definition (.c <-> .h)" })

-- Standard LSP Keymaps on Attach (Braindead & Universal)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", smart_goto_definition, vim.tbl_extend("force", opts, { desc = "Go to definition (.c <-> .h)" }))
    vim.keymap.set("n", "<leader>gd", smart_goto_definition, vim.tbl_extend("force", opts, { desc = "Go to definition (.c <-> .h)" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover doc" }))
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
    vim.keymap.set("n", "<leader>cf", function()
      if not has_repo_clang_format(args.buf) then
        vim.notify("Formatting disabled: No .clang-format found in repository", vim.log.levels.WARN)
        return
      end
      vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 2000 })
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
    vim.keymap.set("i", "<C-k>", function()
      local ok_sig, sig = pcall(require, "lsp_signature")
      if ok_sig then
        sig.toggle_float_win()
      else
        vim.lsp.buf.signature_help()
      end
    end, vim.tbl_extend("force", opts, { desc = "Signature help" }))

    -- Automatic function arguments popup as you write/type arguments
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.signatureHelpProvider then
      local ok_sig, sig = pcall(require, "lsp_signature")
      if ok_sig then
        sig.on_attach({
          bind = true,
          floating_window = true,
          floating_window_above_cur_line = true,
          hint_enable = false,
          handler_opts = { border = "rounded" },
          hi_parameter = "LspSignatureActiveParameter",
          always_trigger = true,
          extra_trigger_chars = { "(", "," },
          timer_interval = 60,
          check_completion_visible = true,
        }, args.buf)
      end
    end
  end,
})

-- Diagnostic Configuration:
-- Colors the actual line numbers directly (Errors > Warnings > Info > Hint)
-- with colored underlines and undercurls enabled
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
    },
    priority = 200, -- Higher than mini.diff (50) so errors & warnings take precedence
  },
  underline = true,
  virtual_text = false,
  severity_sort = true,
})

-- Standard Diagnostic Navigation
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic error" })

-- Toggle buffer errors window (<leader>q)
local function toggle_buffer_errors()
  local loc_open = false
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      loc_open = true
      break
    end
  end
  if loc_open then
    vim.cmd("lclose")
    return
  end

  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify("no errors", vim.log.levels.INFO)
    return
  end

  vim.diagnostic.setloclist({ open = true })
end

vim.keymap.set("n", "<leader>q", toggle_buffer_errors, { desc = "Toggle buffer errors" })

-- Autoformat on save with toggle (<leader>F)
-- By default, autoformat only runs if .clang-format is found in the repository
local autoformat_enabled = true

local function toggle_autoformat()
  autoformat_enabled = not autoformat_enabled
  local msg = autoformat_enabled and "format on" or "format off"
  vim.notify(msg, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>F", toggle_autoformat, { desc = "Toggle autoformat" })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.h", "*.cpp", "*.hpp" },
  callback = function(args)
    if not autoformat_enabled then
      return
    end
    -- Disable formatting by default if .clang-format is not found in the repository
    if not has_repo_clang_format(args.buf) then
      return
    end
    local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "clangd" })
    if #clients > 0 then
      vim.lsp.buf.format({ bufnr = args.buf, id = clients[1].id, timeout_ms = 1000 })
    end
  end,
})


