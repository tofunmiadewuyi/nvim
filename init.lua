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
-- vim.o.relativenumber = true

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

-- search
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

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

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.keymap.set('n', '<leader>i', function()
--  vim.diagnostic.goto_next()
--  end, opts)

-- LEADERS
vim.keymap.set('n', '<leader>w', ':update<Return>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<Return>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>Q', ':qa<Return>', { desc = 'Quit all' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds for commenting
vim.keymap.set('n', '<D-/>', 'gcc', { desc = 'Toggle comment line', remap = true })
vim.keymap.set('v', '<D-/>', 'gc', { desc = 'Toggle comment selection', remap = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

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

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier:
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--
-- local term_buf_id = nil
-- local term_win_id = nil
--
-- vim.keymap.set('n', '<leader>st', function()
--   -- Check if terminal window exists and is visible
--   if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
--     -- Terminal is visible, hide it
--     vim.api.nvim_win_close(term_win_id, false)
--     term_win_id = nil
--   else
--     -- Terminal is hidden or doesn't exist
--     if term_buf_id and vim.api.nvim_buf_is_valid(term_buf_id) then
--       -- Reuse existing terminal buffer
--       vim.cmd.split()
--       vim.cmd.wincmd 'J'
--       vim.api.nvim_win_set_height(0, 15)
--       vim.api.nvim_win_set_buf(0, term_buf_id)
--       term_win_id = vim.api.nvim_get_current_win()
--     else
--       -- Create new terminal
--       vim.cmd.split()
--       vim.cmd.term()
--       vim.cmd.wincmd 'J'
--       vim.api.nvim_win_set_height(0, 7)
--       term_buf_id = vim.api.nvim_get_current_buf()
--       term_win_id = vim.api.nvim_get_current_win()
--     end
--   end
-- end, { desc = 'Toggle terminal' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostic issue' })

-- LAZY PLUGIN MANAGER
require 'config.lazy'

-- THEMES
require 'config.theme'

-- LSPs
require 'config.lsp'

-- COMPLETION
require 'config.cmp'

-- -- FOLD
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldenable = false -- start with folds open

-- floating terminal
vim.keymap.set('n', '<leader>t', ':FloatermToggle<CR>', { desc = 'Toggle Floating Terminal' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:FloatermToggle<CR>', { desc = 'Exit terminal mode' })

vim.opt.termguicolors = true
require('bufferline').setup {
  options = {
    diagnostics = 'nvim_lsp',
    separator_style = 'slant', -- or "slant" for underlines
    -- show_buffer_close_icons = false,
    -- show_close_icon = false,
  },
}
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
