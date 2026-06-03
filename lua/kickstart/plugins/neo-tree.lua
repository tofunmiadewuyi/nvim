-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.keymap.set('n', '<M-b>', ':Neotree toggle<CR>', { desc = 'Toggle File Explorer' })

-- Close Neo-tree before quitting so its buffer isn't restored on the next session
vim.api.nvim_create_autocmd('QuitPre', {
  group = vim.api.nvim_create_augroup('neotree-close-on-quit', { clear = true }),
  callback = function()
    vim.cmd 'silent! Neotree close'
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == 'neo-tree' then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end,
})

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        always_show = {
          '.env',
          '.gitignore',
          '.nvmrc',
          '.github',
          '.prettierrc',
        },
      },
      window = {
        position = 'right',
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      hijack_netrw_behavior = 'open_current',
    },
  },
}
