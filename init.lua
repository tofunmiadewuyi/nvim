--[[

=====================================================================
========                                    .-----.          ========
= ======         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

--]]

-- LEADER
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- UI / DISPLAY
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false           -- mode already shown in statusline
vim.o.cursorline = true
vim.o.scrolloff = 10             -- lines of context above/below cursor
vim.o.signcolumn = 'no'
vim.o.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'       -- live preview of substitutions in split
vim.opt.numberwidth = 1
vim.opt.termguicolors = true
vim.opt.title = true             -- set terminal window title to buffer name

-- EDITING
vim.o.breakindent = true         -- wrapped lines preserve indentation
vim.opt.autoindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.expandtab = true         -- spaces instead of tabs
vim.opt.backspace = { 'start', 'eol', 'indent' } -- backspace over indentation
vim.o.mouse = 'a'                -- enable mouse (useful for resizing splits)

-- SEARCH
vim.o.ignorecase = true
vim.o.smartcase = true           -- case-sensitive when query has capitals
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

-- FILES / PERSISTENCE
vim.o.undofile = true
vim.o.autoread = true            -- auto-reload files changed outside nvim
vim.opt.swapfile = false
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus' -- sync clipboard with OS (scheduled to avoid startup delay)
end)

-- WINDOWS / TIMING
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 250           -- affects diagnostic delay and CursorHold
vim.o.timeoutlen = 300           -- ms to wait for mapped key sequence
vim.o.confirm = true             -- prompt to save instead of erroring on :q

-- KEYMAPS
vim.keymap.set('n', '<Esc>', function()
  vim.fn.setreg('/', '')
  vim.cmd 'nohlsearch'
end)                                                                                   -- clear search highlight

vim.keymap.set('n', '<leader>w', ':noautocmd write<CR>',  { desc = 'Save without formatting' })
vim.keymap.set({ 'n', 'v' }, '<leader>x', '"_d',  { desc = 'Delete without yanking' })
vim.keymap.set('x',          '<leader>p', '"_dP', { desc = 'Paste over selection without losing yank' })
vim.keymap.set('n', '<D-s>',     ':update<Return>',       { desc = 'Save' })
vim.keymap.set('i', '<D-v>',     '<C-r>+',                { noremap = true })         -- paste in insert mode

vim.keymap.set('n', '<D-/>', 'gcc', { desc = 'Toggle comment line',      remap = true })
vim.keymap.set('v', '<D-/>', 'gc',  { desc = 'Toggle comment selection', remap = true })

vim.keymap.set('n', '<leader>rc', function()
  vim.cmd 'source ~/.config/nvim/init.lua'
  vim.notify('Config reloaded!', vim.log.levels.INFO, { title = 'Neovim' })
  vim.api.nvim_echo({ { 'Config reloaded!', 'WarningMsg' } }, false, {})
end, { desc = 'Reload config' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

vim.keymap.set('n', '<left>',  '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>',    '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>',  '<cmd>echo "Use j to move!!"<CR>')

-- AUTOCMDS
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- TREESITTER stale-node crash workaround (TSNode userdata becomes invalid after async reparse)
local _orig_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
  if node == nil then return '' end
  local ok, result = pcall(_orig_get_node_text, node, source, opts)
  return ok and result or ''
end

-- MODULES
require 'config.lazy'
require 'config.lsp'
require 'config.term'
require 'custom.plugins'

-- COLORSCHEME
vim.cmd.colorscheme 'kanagawa-dragon'
