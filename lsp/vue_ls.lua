return {
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
