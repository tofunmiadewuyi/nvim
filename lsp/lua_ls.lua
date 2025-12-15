return {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
      workspace = {
        library = vim.list_extend(
          { vim.fn.expand '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations' },
          vim.api.nvim_get_runtime_file('', true)
        ),
        checkThirdParty = false,
      },
      diagnostics = { globals = { 'vim', 'hs' } },
      runtime = { version = 'LuaJIT' },
      telemetry = { enable = false },
    },
  },
}
