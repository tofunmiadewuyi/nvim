vim.g.rustaceanvim = {
  server = {
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        checkOnSave = true,
        files = {
          watcher = "client",
        },
      },
    },
  },
}
