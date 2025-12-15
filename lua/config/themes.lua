return {

  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true, opts = ... },

  { -- ROSE PINE THEME
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        palette = {
          main = {
            base = '#050310',
          },
        },
      }
    end,
  },

  { -- nightfox
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup {
        options = {
          styles = {
            comments = 'italic',
            keywords = 'bold',
            types = 'italic,bold',
          },
        },
      }
    end,
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }
    end,
  },
}
