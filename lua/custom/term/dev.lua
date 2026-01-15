local utils = require 'custom.term.utils'
local config = require 'custom.term.config'
local tmux = require 'custom.utils.tmux'

local M = {}

local state = {
  buf = -1,
  win = -1,
  job_id = nil,
  url = nil,
  tmux_window = '',
  tmux_dev_window = '',
  dev_cmd = '',
}

local function detect_dev_command()
  if state.dev_cmd ~= '' then
    return state.dev_cmd, nil
  end

  local package_json_path = vim.fn.getcwd() .. '/package.json'

  if vim.fn.filereadable(package_json_path) == 0 then
    return nil, 'No package.json found in current directory'
  end

  local file = io.open(package_json_path, 'r')
  if not file then
    return nil, 'Could not read package.json'
  end

  local content = file:read '*all'
  file:close()

  local ok, decoded = pcall(vim.fn.json_decode, content)
  if not ok or not decoded then
    return nil, 'Could not parse package.json'
  end

  if decoded.scripts and decoded.scripts.dev then
    local package_manager = 'pnpm'
    if vim.fn.executable 'pnpm' == 0 then
      package_manager = 'npm'
    end

    return package_manager .. ' run dev', nil
  end

  return nil, "No 'dev' script found in package.json"
end

local function start_term_buffer()
  -- Detect dev command
  local dev_cmd, err = detect_dev_command()
  if not dev_cmd then
    vim.api.nvim_echo({ { 'Error: ' .. err, 'ErrorMsg' } }, false, {})

    -- Open terminal for manual input
    local result = utils.create_floating_window('dev', { buf = state.buf })
    state.win = result.win
    state.buf = result.buf

    if vim.bo[state.buf].buftype ~= 'terminal' then
      vim.cmd.term()
    end

    return
  end

  -- Delete old buffer if it exists
  if vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end

  -- Create fresh terminal buffer
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(state.buf, 'dev-terminal')
  vim.bo[state.buf].buflisted = false

  vim.api.nvim_echo({ { 'Starting dev server: ' .. dev_cmd, 'InfoMsg' } }, false, {})

  -- Start dev server
  vim.api.nvim_buf_call(state.buf, function()
    state.job_id = vim.fn.termopen(dev_cmd, {
      on_stdout = function(_, data, _)
        for _, line in ipairs(data) do
          if line and line ~= '' then
            local url = utils.parse_localhost_url(line)
            if url and not state.url then
              state.url = url

              if config.auto_open_browser then
                vim.schedule(function()
                  utils.open_browser(url)
                end)
              end
            end
          end
        end
      end,
      on_exit = function(_, exit_code, _)
        state.job_id = nil
        state.url = nil

        if exit_code ~= 0 then
          -- Show terminal on error
          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(state.win) then
              local result = utils.create_floating_window('dev', { buf = state.buf })
              state.win = result.win
            end
            vim.api.nvim_echo({ { 'Dev server failed (exit code ' .. exit_code .. '). Check terminal for details.', 'ErrorMsg' } }, false, {})
          end)
        else
          vim.api.nvim_echo({ { 'Dev server exited normally', 'WarningMsg' } }, false, {})
        end
      end,
    })
  end)

  if state.job_id <= 0 then
    vim.api.nvim_echo({ { 'Failed to start dev server', 'ErrorMsg' } }, false, {})
  end
end

local function term_dev()
  -- If not running, start it
  if not state.job_id or not vim.api.nvim_buf_is_valid(state.buf) then
    start_term_buffer()
    return
  end

  -- Otherwise toggle window visibility
  if not vim.api.nvim_win_is_valid(state.win) then
    local result = utils.create_floating_window('dev', { buf = state.buf })
    state.win = result.win
  else
    vim.api.nvim_win_hide(state.win)
  end
end

local function tmux_dev()
  -- Detect dev command
  local dev_cmd, err = detect_dev_command()
  if not dev_cmd then
    vim.api.nvim_echo({ { 'Error: ' .. err, 'ErrorMsg' } }, false, {})
    return
  end
  tmux.jump_or_start { suffix = 'dev', cmd = dev_cmd }
end

function M.toggle()
  if config.dev_server == 'tmux' then
    tmux_dev()
  else
    term_dev()
  end
end

return M
