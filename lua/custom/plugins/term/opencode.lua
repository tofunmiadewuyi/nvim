local utils = require('custom.plugins.term.utils')

local M = {}

local state = {
  buf = -1,
  win = -1,
}

local function start()
  local result = utils.create_floating_window('opencode', { buf = state.buf })
  state.win = result.win
  state.buf = result.buf

  vim.fn.termopen('opencode', {
    on_exit = function(job_id, exit_code, event_type)
      vim.api.nvim_echo({ { 'OpenCode terminal exited with code: ' .. exit_code, 'WarningMsg' } }, false, {})
    end,
  })

  vim.api.nvim_echo({ { 'OpenCode terminal started', 'InfoMsg' } }, false, {})
end

function M.toggle()
  if not vim.api.nvim_buf_is_valid(state.buf) then
    start()
  elseif not vim.api.nvim_win_is_valid(state.win) then
    local result = utils.create_floating_window('opencode', { buf = state.buf })
    state.win = result.win
  else
    vim.api.nvim_win_hide(state.win)
  end
end

return M
