-- buffer line combos
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<leader>bd', ':bd <CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bh', ':BufferLineMovePrev<CR>', { desc = 'Move buffer left' })
vim.keymap.set('n', '<leader>bl', ':BufferLineMoveNext<CR>', { desc = 'Move buffer right' })
vim.keymap.set('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, { desc = 'Close all buffers except current' })
-- Move buffer to far left
vim.keymap.set('n', '<leader>bH', function()
  for i = 1, vim.fn.bufnr '$' do
    vim.cmd 'BufferLineMovePrev'
  end
end, { desc = 'Move buffer to start' })

-- Move buffer to far right
vim.keymap.set('n', '<leader>bL', function()
  for i = 1, vim.fn.bufnr '$' do
    vim.cmd 'BufferLineMoveNext'
  end
end, { desc = 'Move buffer to end' })
-- pick buffer
vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { desc = 'Pick buffer position' })

return {
  { -- BUFFERLINE
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          diagnostics = 'nvim_lsp',
          separator_style = 'thick', -- or "slant" for underlines
          show_buffer_close_icons = false,
          -- show_close_icon = false,
          custom_filter = function(buf_number)
            local buf_name = vim.fn.bufname(buf_number)
            local excluded_patterns = { 'dev%-terminal', 'opencode%-terminal' }

            for _, pattern in ipairs(excluded_patterns) do
              if buf_name:match(pattern) then
                return false
              end
            end

            return true
          end,
        },
        highlights = require('vesper').bufferline.highlights,
      }
    end,
  },
}
