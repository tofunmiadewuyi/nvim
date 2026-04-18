return {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
      workspace = { checkThirdParty = false },
      diagnostics = { globals = { 'vim', 'hs' } },
      runtime = { version = 'LuaJIT' },
      telemetry = { enable = false },
    },
  },
}
