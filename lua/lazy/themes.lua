return {

  { 'ellisonleao/gruvbox.nvim', config = true, opts = ... },

  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        background = "hard",
        transparent_background_level = 2,
      })
      vim.cmd([[colorscheme everforest]])
    end,
  },

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

  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
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
