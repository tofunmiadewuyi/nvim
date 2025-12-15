
-- local mason_registry = require 'mason-registry'


local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'typescript.d' }
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

return {
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

