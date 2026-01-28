-- general purpose terminal
local utils = require 'custom.term.utils'
local config = require 'custom.term.config'
local tmux = require 'custom.utils.tmux'

local M = {}

local state = {
  buf = -1,
  win = -1,
  term = nil,
}

local function buffer_term()
  if not vim.api.nvim_win_is_valid(state.win) then
    local result = utils.create_floating_window('general', { buf = state.buf })
    state.win = result.win
    state.buf = result.buf

    if vim.bo[state.buf].buftype ~= 'terminal' then
      -- Start terminal in the buffer
      vim.fn.termopen(vim.o.shell)
    end
  else
    vim.api.nvim_win_hide(state.win)
  end
end

function M.toggle()
  if config.new_term == 'tmux' then
    tmux.jump_or_start { suffix = 'term' }
  else
    buffer_term()
  end
end

function M.new()
  if not config.new_term == 'tmux' then
    return
  end

  if state.term == nil then
    state.term = 0
  end

  state.term = state.term + 1
  tmux.jump_or_start { suffix = 'term-' .. state.term }
  vim.keymap.set({ 't', 'n' }, '<leader>t' .. state.term, function()
    tmux.jump_or_start { suffix = 'term-' .. state.term }
  end, { desc = 'Jump to terminal ' .. state.term })
end

return M
