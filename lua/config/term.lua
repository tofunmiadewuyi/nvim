-- Exit terminal mode keybind
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Load terminal modules
local general = require('custom.term.general')
-- local opencode = require('custom.term.opencode')
local dev = require('custom.term.dev')

-- Commands
vim.api.nvim_create_user_command('Floaterm', general.toggle, {})
-- vim.api.nvim_create_user_command('OpenCode', opencode.toggle, {})
vim.api.nvim_create_user_command('Dev', dev.toggle, {})

-- Keybinds
vim.keymap.set({ 't', 'n' }, '<leader>tt', general.toggle, { desc = 'Toggle floating terminal' })
-- vim.keymap.set({ 't', 'n' }, '<leader>tc', opencode.toggle, { desc = 'Toggle OpenCode terminal' })
vim.keymap.set({ 't', 'n' }, '<leader>td', dev.toggle, { desc = 'Toggle dev server terminal' })
