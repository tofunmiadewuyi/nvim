-- Set the delay (in milliseconds) before showing diagnostic
vim.opt.updatetime = 500 -- 500ms delay, adjust as needed

vim.keymap.set('n', '<leader>di', vim.diagnostic.open_float, { desc = 'Open diagnostic issue' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Show diagnostic popup automatically after cursor stops moving
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
    }
    local _, winid = vim.diagnostic.open_float(nil, opts)
    -- Auto-close after defined seconds
    if winid then
      vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, true)
        end
      end, 7000)
    end
  end,
})

local function yank_line_diagnostics()
  local bufnr = 0
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

  local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
  if vim.tbl_isempty(diags) then
    vim.notify('No diagnostics on this line', vim.log.levels.INFO)
    return
  end

  local msg = {}
  for _, d in ipairs(diags) do
    table.insert(msg, d.message)
  end

  local text = table.concat(msg, '\n---\n')
  vim.fn.setreg('+', text)
  vim.notify('Diagnostic issue yanked', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('YankDiag', yank_line_diagnostics, {})

vim.keymap.set('n', '<leader>dy', yank_line_diagnostics, {
  desc = 'Yank diagnostics under cursor',
})

vim.keymap.set('n', '<leader>dn', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Jump to next diagnostic issue' })

vim.keymap.set('n', '<leader>dp', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Jump to prev diagnostic issue' })
