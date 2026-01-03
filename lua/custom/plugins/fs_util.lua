local uv = vim.uv -- libuv for filesystem

local M = {}
M.is_dir = function(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == 'directory'
end

M.file_exists = function(path)
  local stat = uv.fs_stat(path)
  return stat ~= nil
end

-- Detect project root by looking for markers
M.find_project_root = function(markers, opts)
  local o = { path_mod = ':t' }

  if opts and opts.fullpath and opts.fullpath == true then
    o.path_mod = ':p:h'
  end

  if opts and opts.start_dir then
    o.start_dir = opts.start_dir
  else
    local buf_path = vim.api.nvim_buf_get_name(0)
    local buf_dir = vim.fn.fnamemodify(buf_path, ':p:h')
    o.start_dir = buf_dir
  end

  -- local cwd = vim.fn.getcwd()
  -- local dir = start_dir or cwd

  local dir = o.start_dir

  local function modify_result(path)
    return vim.fn.fnamemodify(path, o.path_mod)
  end

  while dir do
    for _, m in ipairs(markers) do
      if M.file_exists(dir .. '/' .. m) then
        return modify_result(dir) -- found a project marker
      end
    end

    -- go up one directory
    local parent = dir:match '^(.*)/[^/]+$'
    if not parent or parent == dir then
      break -- reached filesystem root
    end
    dir = parent
  end

  return nil -- no project found
end

return M
