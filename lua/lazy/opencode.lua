return {
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { 'folke/snacks.nvim', opts = { input = {}, picker = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- provider = {
        --   enabled = 'tmux',
        --   tmux = {
        --     -- Create new window instead of split pane
        --     session = 'dev',
        --   },
        -- },
      }

      -- load tmux utils
      local tmux = require 'custom.utils.tmux'

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode' })

      vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })

      vim.keymap.set({ 'n', 't' }, '<leader>o.', function()
        -- require('opencode').toggle()
        tmux.jump_or_start { suffix = 'ai', cmd = 'opencode --port 3456' }
      end, { desc = 'Toggle opencode' })

      vim.keymap.set({ 'n', 'x' }, 'go', function()
        return require('opencode').operator '@this '
      end, { expr = true, desc = 'Add range to opencode' })

      vim.keymap.set('n', 'goo', function()
        return require('opencode').operator '@this ' .. '_'
      end, { expr = true, desc = 'Add line to opencode' })

      vim.keymap.set('n', '<leader>ou', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'opencode half page up' })

      vim.keymap.set('n', '<leader>od', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'opencode half page down' })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
      vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
      vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
    end,
  },
}
