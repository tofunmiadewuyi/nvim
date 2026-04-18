local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  -- require 'lazy.telescope',
  require 'lazy.treesitter',
  require 'lazy.mini',
  require 'lazy.snacks',
  require 'lazy.themes',
  require 'lazy.buffers',
  require 'lazy.cmp',
  require 'lazy.opencode',
  -- require 'lazy.yazi',

  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',

  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  { -- COMMENTING
    'numToStr/Comment.nvim',
    opts = {},
  },

  { --FLASH
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      -- {
      --   'r',
      --   mode = 'o',
      --   function()
      --     require('flash').remote()
      --   end,
      --   desc = 'Remote Flash',
      -- },
      -- {
      --   'R',
      --   mode = { 'o', 'x' },
      --   function()
      --     require('flash').treesitter_search()
      --   end,
      --   desc = 'Treesitter Search',
      -- },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },

  { -- GITSIGNS
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎' },
        topdelete = { text = '▎' },
        changedelete = { text = '▎' },
        -- add = { text = '+' },
        -- change = { text = '~' },
        -- delete = { text = '_' },
        -- topdelete = { text = '‾' },
        -- changedelete = { text = '~' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- end of line
        delay = 100, -- delay in ms
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    },
  },

  { -- FOLDS
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Add folding capabilities to your LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      require('ufo').setup {
        provider_selector = function(bufnr, filetype)
          if filetype == 'vue' then
            return { 'treesitter', 'indent' }
          end
          return { 'treesitter', 'indent' }
        end,
      }

      -- Keymaps
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
  },

  { -- SMEAR CURSOR
    'sphamba/smear-cursor.nvim',
    opts = {
      smear_between_buffers = false,
      smear_insert_mode = false,
    },
  },

  { -- AUTOTAGS
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- { -- TRANSPARENT
  --   'xiyaowong/transparent.nvim',
  --   name = 'transparent',
  --   config = function()
  --     require('transparent').setup {
  --       extra_groups = {
  --         'TelescopeNormal',
  --         'TelescopeBorder',
  --         'TelescopePromptBorder',
  --         'TelescopeResultsBorder',
  --         'TelescopePreviewBorder',
  --         'TelescopePromptNormal',
  --         'TelescopeResultsNormal',
  --         'TelescopePreviewNormal',
  --         'TelescopePromptTitle',
  --         'TelescopeResultsTitle',
  --         'TelescopePreviewTitle',
  --         'TelescopeSelection',
  --         'TelescopeMatching',
  --
  --         'MiniStatuslineModeInsert',
  --         'MiniStatuslineModeVisual',
  --         'MiniStatuslineModeReplace',
  --         'MiniStatuslineModeCommand',
  --         'MiniStatuslineModeOther',
  --         'MiniStatuslineDevinfo',
  --         'MiniStatuslineFilename',
  --         'MiniStatuslineFileinfo',
  --         'MiniStatuslineInactive',
  --
  --         'FloatBorder',
  --         'FloatTitle',
  --         'Pmenu',
  --         'PmenuBorder',
  --         'NormalFloat',
  --       },
  --     }
  --   end,
  -- },

  { -- WHICH KEY
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Mason and LSP setup
    'mason-org/mason.nvim',
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
      'folke/lazydev.nvim', -- must load before lua_ls config is applied
    },
    config = function()
      require('mason').setup()
      require 'config.lsp'
      require('mason-tool-installer').setup {
        ensure_installed = { 'lua-language-server', 'stylua', 'vue-language-server', 'vtsls', 'prettier', 'css-lsp' },
      }
    end,
  },

  { -- LAZY DEV, vim autocompletions and type defs
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = vim.fn.expand '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations' },
      },
    },
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>bf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 1000,
            lsp_format = 'never',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' }, -- or "eslint"
        vue = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        json = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        go = { 'goimports' },
      },
    },
  },

  { -- TODO COMMENTS
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- RUST LSP
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = 'rust',
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
