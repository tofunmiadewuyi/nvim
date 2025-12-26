-- general purpose floating terminal

local utils = require 'custom.plugins.term.utils'

local M = {}

local state = {
  buf = -1,
  win = -1,
}

function M.toggle()
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

return M
