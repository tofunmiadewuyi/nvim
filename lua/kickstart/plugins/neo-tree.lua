-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.keymap.set('n', '<M-b>', ':Neotree toggle<CR>', { desc = 'Toggle File Explorer' })
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
