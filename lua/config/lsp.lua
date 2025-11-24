-- LSP shenanigans
local mason_registry = require 'mason-registry'
local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'typescript.d' }
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    typescript = {
      preferences = {
        includePackageJsonAutoImports = 'auto',
      },
      suggest = {
        includeCompletionsForModuleExports = true,
      },
    },
    javascript = {
      preferences = {
        includePackageJsonAutoImports = 'auto',
      },
    },
  },

  filetypes = tsserver_filetypes,
}

-- local ts_ls_config = {
--   init_options = {
--     plugins = {
--       vue_plugin,
--     },
--   },
--   filetypes = tsserver_filetypes,
-- }

local vue_ls_config = {
  filetypes = { 'vue' },
  init_options = {
    vue = {
      hybridMode = false, -- Important for template intellisense
    },
    typescript = {
      tsdk = vim.fn.expand '$MASON/packages/typescript-language-server/node_modules/typescript/lib',
    },
  },
}

vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)
-- vim.lsp.config('tsgo', {})
-- vim.lsp.config('ts_ls', ts_ls_config)
vim.lsp.enable { 'vtsls', 'vue_ls' }
--
-- local base_on_attach = vim.lsp.config.eslint.on_attach
-- vim.lsp.config('eslint', {
--   on_attach = function(client, bufnr)
--     if not base_on_attach then
--       return
--     end
--
--     base_on_attach(client, bufnr)
--     vim.api.nvim_create_autocmd('BufWritePre', {
--       buffer = bufnr,
--       command = 'LspEslintFixAll',
--     })
--   end,
-- })
