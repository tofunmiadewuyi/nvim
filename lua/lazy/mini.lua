-- Session management keybinds
vim.keymap.set('n', '<leader>qs', ':lua MiniSessions.select()<CR>', { desc = 'Select/Restore Session' })
vim.keymap.set('n', '<leader>qw', function()
  local session_name = vim.fn.input 'Session name: '
  if session_name ~= '' then
    require('mini.sessions').write(session_name)
    vim.notify('Session "' .. session_name .. '" saved!', vim.log.levels.INFO)
  end
end, { desc = 'Write/Save Session' })

vim.keymap.set('n', '<leader>qd', function()
  MiniSessions.delete(nil, { force = true })
end, { desc = 'Delete current Session' })

local function session_exists(name)
  -- local path = mini_sessions.config.options.directory .. "/" .. name .. ".vim"
  local path = vim.fn.stdpath 'data' .. '/sessions/' .. name
  local f = io.open(path, 'r')
  if f then
    f:close()
    return true
  end
  return false
end

vim.api.nvim_create_autocmd('SessionLoadPost', {
  callback = function()
    vim.cmd 'filetype detect'
  end,
  desc = 'Re-run filetype detection after session load',
})

-- Detect project and create/save session
local auto_setup_session = function()
  -- if nvim was opened with an arg then don't bother
  if vim.fn.argc() ~= 0 then
    vim.notify 'Session excluded'
    return
  end

  local fs_util = require 'custom.plugins.fs_util'

  local markers = { '.git', 'package.json', 'pyproject.toml', 'Cargo.toml', 'go.mod' }
  local root = fs_util.find_project_root(markers)

  if not root then
    vim.notify 'Could not start session'
    return
  end

  local ms = require 'mini.sessions'
  if session_exists(root) then
    ms.read(root)
    vim.notify("Cont'd session @ " .. root)
  else
    ms.write(root)
    vim.notify('Started session @ ' .. root)
  end
end

return {
  { -- MINI
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        mappings = {
          add = 'ys',
          delete = 'ds',
          replace = 'cs',
          find = '',
          find_left = '',
          highlight = '',
          update_n_lines = '',
        },
      }

      -- Sessions support
      require('mini.sessions').setup {
        autoread = false,
        autowrite = true,
        directory = vim.fn.stdpath 'data' .. '/sessions/',
      }

      vim.api.nvim_create_autocmd('VimEnter', { callback = auto_setup_session })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
            local git = MiniStatusline.section_git { trunc_width = 75 }
            -- local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
            local location = MiniStatusline.section_location { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git } },
              -- '%=', -- left/right separator
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=',
              { hl = mode_hl, strings = { location } },
            }
          end,
        },
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
