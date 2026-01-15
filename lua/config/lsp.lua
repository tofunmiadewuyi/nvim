-- LSP Configuration

-- Keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    -- map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    -- map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    -- map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
    -- map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    -- map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
    map('grr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
    map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
    map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
    map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
    map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
    map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Document highlight on cursor hold
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay hints toggle
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Diagnostics
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
  },
}


-- Setup LSP configurations with proper Mason paths
local mason_bin = vim.fn.stdpath('data') .. '/mason/bin/'

-- Get blink.cmp capabilities
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Load configurations and add command paths + capabilities
local lua_ls_config = dofile(vim.fn.stdpath('config') .. '/lsp/lua_ls.lua')
lua_ls_config.cmd = { mason_bin .. 'lua-language-server' }
lua_ls_config.filetypes = { 'lua' }
lua_ls_config.capabilities = capabilities

local vtsls_config = dofile(vim.fn.stdpath('config') .. '/lsp/vtsls.lua')
vtsls_config.cmd = { mason_bin .. 'vtsls', '--stdio' }
vtsls_config.capabilities = capabilities

local gopls_config = dofile(vim.fn.stdpath('config') .. '/lsp/gopls.lua')

vim.lsp.config('lua_ls', lua_ls_config)
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('gopls', gopls_config)

-- Enable the LSP servers
vim.lsp.enable { 'lua_ls', 'vtsls', 'gopls' }

-- Add a simple LSP info command
vim.api.nvim_create_user_command('LspStatus', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    print('No LSP clients attached to current buffer')
  else
    print('LSP clients attached to current buffer:')
    for _, client in pairs(clients) do
      print('  - ' .. client.name .. ' (id: ' .. client.id .. ')')
    end
  end
end, { desc = 'Show LSP client status for current buffer' })


-- Custom LSP hover window
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
  max_width = 80,
  max_height = 20,
  focusable = false,
  close_events = { 'CursorMoved', 'BufLeave', 'InsertEnter' },
  stylize_markdown = true,
})

vim.keymap.set('n', '<leader>lr', ':LspRestart <CR>', { desc = 'Restart LSP' })
vim.keymap.set('n', '<leader>ls', ':LspStatus <CR>', { desc = 'LSP Status' })

