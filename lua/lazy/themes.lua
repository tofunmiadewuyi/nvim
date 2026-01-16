return {

  { 'ellisonleao/gruvbox.nvim', config = true, opts = ... },

  {
    'datsfilipe/vesper.nvim',
    config = function()
      require('vesper').setup {
        transparent = false,
        italics = {
          comments = true,
          keywords = true,
          functions = true,
          strings = true,
          variables = true,
        },
        overrides = {},
        palette_overrides = {},
      }
    end,
  },

  { -- ROSE PINE THEME
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        palette = {
          -- main = {
          --   base = '#050310',
          -- },
        },
      }
    end,
  },

  -- { -- nightfox
  --   'EdenEast/nightfox.nvim',
  --   config = function()
  --     require('nightfox').setup {
  --       options = {
  --         styles = {
  --           comments = 'italic',
  --           keywords = 'bold',
  --           types = 'italic,bold',
  --         },
  --       },
  --     }
  --   end,
  -- },

  {
    'vague-theme/vague.nvim',
    -- use vim.o.background - 'dark' or :set background=dark
  },
  {
    'gmr458/cold.nvim',
  },

  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('tokyonight').setup {
  --       styles = {
  --         comments = { italic = false }, -- Disable italics in comments
  --       },
  --     }
  --   end,
  -- },
}
