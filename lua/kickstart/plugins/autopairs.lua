-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  dependencies = { 'hrsh7th/nvim-cmp' },
  event = 'InsertEnter',
  opts = {},
  config = function()
    require('nvim-autopairs').setup {
      check_ts = true, -- enable treesitter
    }

    -- Integration with completion
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
