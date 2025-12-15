--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
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

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used) --
--]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

--use buffer title
vim.opt.title = true
-- allow backspace over indentation
vim.opt.backspace = { 'start', 'eol', 'indent' }
-- Enable break indent
vim.o.breakindent = true
vim.opt.autoindent = true
--vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.swapfile = false

-- search
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'no'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.numberwidth = 1
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- hide cms line
vim.o.cmdheight = 0

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', function()
  vim.fn.setreg('/', '')
  vim.cmd 'nohlsearch'
end)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.keymap.set('n', '<leader>i', function()
--  vim.diagnostic.goto_next()
--  end, opts)

-- LEADERS
vim.keymap.set('n', '<leader>w', ':noa w<Return>', { desc = 'Save file without formatting' })
vim.keymap.set('n', '<D-s>', ':update<Return>', { desc = 'Save file with formatting' })
-- vim.keymap.set('n', '<leader>q', ':q<Return>', { desc = 'Quit' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds for commenting
vim.keymap.set('n', '<D-/>', 'gcc', { desc = 'Toggle comment line', remap = true })
vim.keymap.set('v', '<D-/>', 'gc', { desc = 'Toggle comment selection', remap = true })

-- Reload Config
vim.keymap.set('n', '<leader>rc', function()
  vim.cmd 'source ~/.config/nvim/init.lua'
  vim.notify('Config reloaded!', vim.log.levels.INFO, { title = 'Neovim' })
end, { desc = 'Reload config' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostic issue' })

-- LAZY
require 'config.lazy'
-- THEMES
require 'config.theme'
-- LSPs
require 'config.lsp'
-- COMPLETION
require 'config.cmp'

vim.cmd.colorscheme 'terafox'

-- Override gitsigns colors after colorscheme loads
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#1D422C' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#474550' })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#ff0000' })
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#0E0C19', fg = '#E2E8F0' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = '#F2BE75' })

vim.opt.termguicolors = true

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n><C-o>', { desc = 'Exit terminal and go to previous buffer' })

-- Show diagnostic popup automatically after cursor stops moving
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
    }
    local _, winid = vim.diagnostic.open_float(nil, opts)
    -- Auto-close after 3 seconds
    if winid then
      vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, true)
        end
      end, 7000)
    end
  end,
})

-- Set the delay (in milliseconds) before showing diagnostic
vim.opt.updatetime = 500 -- 500ms delay, adjust as needed

-- buffer line combos
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<leader>bd', ':bd <CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bh', ':BufferLineMovePrev<CR>', { desc = 'Move buffer left' })
vim.keymap.set('n', '<leader>bl', ':BufferLineMoveNext<CR>', { desc = 'Move buffer right' })
vim.keymap.set('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, { desc = 'Close all buffers except current' })
-- Move buffer to far left
vim.keymap.set('n', '<leader>bH', function()
  for i = 1, vim.fn.bufnr '$' do
    vim.cmd 'BufferLineMovePrev'
  end
end, { desc = 'Move buffer to start' })

-- Move buffer to far right
vim.keymap.set('n', '<leader>bL', function()
  for i = 1, vim.fn.bufnr '$' do
    vim.cmd 'BufferLineMoveNext'
  end
end, { desc = 'Move buffer to end' })
-- pick buffer
vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { desc = 'Pick buffer position' })

-- Custom LSP hover window
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
  max_width = 80,
  max_height = 20,
  focusable = false,
  close_events = { 'CursorMoved', 'BufLeave', 'InsertEnter' },
  stylize_markdown = true,
})

vim.keymap.set('n', '<leader>lr', ':LspRestart <CR>', { desc = 'Restart LSP' })
vim.keymap.set('n', '<leader>li', ':LspInfo <CR>', { desc = 'LSP Info' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
