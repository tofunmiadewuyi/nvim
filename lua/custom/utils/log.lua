local M = {}

function M.clearLogs()
  io.open(vim.fn.getcwd() .. '/tmux_dev.log', 'w'):close()
end
function M.log(msg)
  local file = io.open(vim.fn.getcwd() .. '/tmux_dev.log', 'a')
  if file then
    file:write(msg .. '\n')
    file:close()
  end
end

return M
