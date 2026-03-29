return {
  cmd = { vim.fn.expand '~/.local/share/nvim/mason/packages/zls/zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'build.zig', 'build.zig.zon', '.git' },
}
