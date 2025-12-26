local M = {}
local config = require('custom.plugins.term.config')

-- Strip ANSI escape codes from text
function M.strip_ansi_codes(text)
  if not text then
    return text
  end
  return text:gsub('\27%[[%d;]*m', '')
end

-- Parse localhost URL from terminal output
function M.parse_localhost_url(text)
  local clean_text = M.strip_ansi_codes(text)
  if not clean_text then
    return nil
  end

  local patterns = {
    'https?://localhost:(%d+)',
    'https?://127%.0%.0%.1:(%d+)',
    'Local:%s+(https?://localhost:%d+)',
    'Local:%s+(https?://[^%s]+)',
    '➜%s+Local:%s+(https?://[^%s]+)',
    '➜%s+Network:%s+(https?://[^%s]+)',
  }

  for _, pattern in ipairs(patterns) do
    local match = clean_text:match(pattern)
    if match then
      if match:match '^%d+$' then
        return 'http://localhost:' .. match
      else
        return match
      end
    end
  end

  return nil
end

-- Open URL in browser
function M.open_browser(url)
  if not url then
    return
  end

  local open_cmd
  if vim.fn.has 'mac' == 1 then
    open_cmd = 'open'
  elseif vim.fn.has 'unix' == 1 then
    open_cmd = 'xdg-open'
  elseif vim.fn.has 'win32' == 1 then
    open_cmd = 'start'
  else
    vim.api.nvim_echo({ { 'Could not detect OS to open browser', 'WarningMsg' } }, false, {})
    return
  end

  vim.fn.jobstart({ open_cmd, url }, { detach = true })
  vim.api.nvim_echo({ { 'Opened browser: ' .. url, 'InfoMsg' } }, false, {})
end

-- Create floating window
function M.create_floating_window(name, opts)
  opts = opts or {}
  local size = config.win_config.size or 0.8
  local width = opts.width or math.floor(vim.o.columns * size)
  local height = opts.height or math.floor(vim.o.lines * size)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf or -1) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, name .. '-terminal')
    vim.bo[buf].buflisted = false
  end

  local win_config = {
    relative = config.win_config.relative or 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = config.win_config.style or 'minimal',
    border = config.win_config.border or 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

return M
