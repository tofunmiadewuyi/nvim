-- Terminal configuration
return {
  auto_open_browser = true,
  dev_server = 'tmux', -- 'tmux' | 'term'
  win_config = {
    relative = 'editor',
    size = 0.8, -- relative to above
    style = 'minimal',
    border = 'rounded',
  }
}
