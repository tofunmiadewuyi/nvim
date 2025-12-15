-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
  config = function()
    require('nvim-autopairs').setup {
      check_ts = true, -- enable treesitter
    }
  end,
}
