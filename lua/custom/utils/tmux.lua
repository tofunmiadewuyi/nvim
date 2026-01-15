local M = {}

local tmux_window_name = vim.fn.system("tmux display-message -p '#W'"):gsub('\n', '')
local count = 0

function M.start_in_tmux(opts)
  opts = opts or {}
  local suffix = opts.suffix or tostring(count)
  local nwindow_name = opts.name or tmux_window_name .. '-' .. suffix
  vim.notify('Creating new window with name: ' .. nwindow_name)
  vim.fn.system('tmux new-window -n ' .. nwindow_name)
  if opts.cmd then
    vim.fn.system('tmux send-keys -t :=' .. nwindow_name .. ' "' .. opts.cmd .. '" Enter'):gsub('\n', '')
  end
  count = count + 1
  return nwindow_name
end

function M.jump_to_window(name)
  local windows = vim.fn.system "tmux list-windows -F '#{window_name}'"

  local found = false
  for window_name in windows:gmatch '[^\n]+' do
    if window_name == name then
      found = true
      break
    end
  end

  if found then
    vim.fn.system('tmux select-window -t ' .. name)
    return true
  end

  return false
end

function M.jump_or_start(opts)
  opts = opts or {}
  local name = opts.name
  if opts.suffix then
    name = tmux_window_name .. '-' .. opts.suffix
  end
  local ok = M.jump_to_window(name)
  if not ok then
    return M.start_in_tmux(opts)
  else
    return name
  end
end

return M
