# My Neovim Config

This is my personal Neovim setup.

It started from `kickstart.nvim`, but it is no longer the stock template. I have split the config into focused modules, changed the editing workflow around my own habits, and added a few custom tools for terminals, sessions, diagnostics, and language-server setup.

The goal of this config is simple:

- keep startup and maintenance straightforward
- make project navigation fast
- make LSP and diagnostics usable without extra noise
- make terminal-heavy web development feel native inside Neovim

## What This Config Is Built Around

This setup is for how I actually work, not for trying to be a full Neovim distribution.

It is centered around:

- `lazy.nvim` for plugin management
- `snacks.nvim` for picker, dashboard, git UI, and general navigation
- `blink.cmp` + `LuaSnip` for completion and snippets
- built-in Neovim LSP with separate per-server configs
- `mini.nvim` modules for sessions, statusline, text objects, pairs, and surround
- tmux-aware terminals for running shells and dev servers

The overall style is minimal but practical: relative numbers, small statusline, strong LSP defaults, fast search, session restore, and a floating-terminal workflow when needed.

## Features

- Automatic plugin bootstrap through `lazy.nvim`
- Project sessions with auto-detect and auto-restore via `mini.sessions`
- `Snacks` dashboard and picker-first navigation
- LSP setup for:
  - Lua
  - TypeScript / JavaScript / Vue
  - Go
  - Zig
  - CSS / SCSS / Less
- Completion with `blink.cmp`
- Snippets with `LuaSnip` and `friendly-snippets`
- Buffer management with `bufferline.nvim`
- Git integration with `gitsigns.nvim` and `Snacks.lazygit()`
- Folding with `nvim-ufo`
- Motion with `flash.nvim`
- Auto tag closing with `nvim-ts-autotag`
- Floating diagnostics with yank/copy support
- Floating terminal support and tmux-backed terminal workflows
- Dev server launcher that detects `package.json` and runs `dev`
- Browser auto-open when a localhost URL is detected from terminal output
- Custom tmux helpers for jumping to or creating task-specific windows

## Structure

This config is organized by responsibility instead of keeping everything inside `init.lua`.

```text
.
├── init.lua
├── lua/
│   ├── config/
│   │   ├── lazy.lua
│   │   ├── lsp.lua
│   │   └── term.lua
│   ├── custom/
│   │   ├── plugins/
│   │   ├── term/
│   │   └── utils/
│   ├── kickstart/
│   └── lazy/
├── lsp/
├── snippets/
└── doc/
```

### Important Files

- `init.lua`
  Sets editor options, keymaps, autocommands, and loads the main modules.

- `lua/config/lazy.lua`
  Bootstraps `lazy.nvim` and registers the plugin specs.

- `lua/config/lsp.lua`
  Configures diagnostics, LSP keymaps, hover UI, capabilities, and enables language servers.

- `lua/config/term.lua`
  Defines terminal commands and terminal keymaps.

- `lua/lazy/*.lua`
  Plugin specs grouped by purpose instead of keeping one giant plugin file.

- `lua/custom/term/*.lua`
  My terminal workflow:
  - general floating terminal
  - dev server terminal
  - shared terminal utilities
  - runtime terminal config

- `lua/custom/utils/tmux.lua`
  Tmux integration for creating or jumping to named windows from inside Neovim.

- `lua/custom/plugins/diagnostics.lua`
  Extra diagnostic UX: popup on hold, jump helpers, and yank diagnostics for the current line.

- `lua/custom/plugins/fs_util.lua`
  Small filesystem helpers, mainly for project-root detection.

- `lsp/*.lua`
  Per-language server configuration files.

- `snippets/`
  Custom snippets, currently including Vue snippets.

## How It Works

### Startup

When Neovim starts:

1. `init.lua` applies the base editor settings and keymaps.
2. `config.lazy` bootstraps plugins if needed.
3. `config.lsp` sets up diagnostics and language servers.
4. `config.term` registers terminal commands.
5. `custom.plugins` loads extra local behavior such as diagnostic helpers.
6. The colorscheme is applied.

### Sessions

On `VimEnter`, the config tries to detect the project root by looking for markers such as:

- `.git`
- `package.json`
- `pyproject.toml`
- `Cargo.toml`
- `go.mod`

If a saved session exists for that project, it restores it. Otherwise it creates one. This makes the config feel project-aware without needing manual setup every time.

### LSP

LSP is configured in two layers:

- shared behavior in [`lua/config/lsp.lua`](/Users/mac/.config/nvim/lua/config/lsp.lua)
- per-server settings in [`lsp/`](/Users/mac/.config/nvim/lsp)

That keeps global behavior consistent while allowing language-specific overrides. Completion capabilities are provided through `blink.cmp`.

### Terminal Workflow

The terminal system is one of the more personal parts of this config.

- `<leader>tt` toggles the main terminal
- `<leader>tn` creates a new terminal target
- `<leader>td` opens the dev terminal flow

Depending on [`lua/custom/term/config.lua`](/Users/mac/.config/nvim/lua/custom/term/config.lua), terminals can run either:

- inside floating Neovim terminals
- in dedicated tmux windows

The dev terminal can inspect `package.json`, detect a `dev` script, and run `pnpm run dev` or `npm run dev`. If the command outputs a local URL, the config can open the browser automatically.

## Key Workflow Notes

- Search, file finding, git history, diagnostics, and symbol navigation are primarily handled through `Snacks`.
- Buffer movement and ordering are handled with `bufferline`.
- Diagnostics are intentionally visible but controlled:
  - popup on cursor hold
  - quick jump next/previous
  - copy current line diagnostics to clipboard
- The statusline is kept small and readable with `mini.statusline`.
- The colorscheme defaults to `kanagawa-dragon`.

## Keymaps I Rely On

This is not a full keymap reference, just the main workflow keys.

### General

- `<leader>w` save without formatting
- `<leader>rc` reload config
- `<Esc>` clear search highlight
- `<C-h/j/k/l>` move between windows

### Search / Navigation

- `<leader>sf` search files
- `<leader>sg` grep
- `<leader>sh` help
- `<leader>sk` keymaps
- `<leader>ss` symbols

### Buffers

- `<Tab>` next buffer
- `<S-Tab>` previous buffer
- `<leader>bd` delete buffer
- `<leader>bo` close all other buffers
- `<leader>bp` pick buffer

### Git

- `<leader>gg` open lazygit
- `<leader>gb` branches
- `<leader>gl` git log
- `<leader>gs` git status

### LSP

- `grd` definitions
- `grr` references
- `gri` implementations
- `grt` type definitions
- `<leader>lr` restart LSP
- `<leader>ls` show attached LSP clients

### Diagnostics

- `<leader>di` open diagnostic float
- `<leader>dn` next diagnostic
- `<leader>dp` previous diagnostic
- `<leader>dy` yank diagnostics under cursor

### Sessions

- `<leader>qs` select / restore session
- `<leader>qw` save session
- `<leader>qd` delete session

### Terminal

- `<leader>tt` toggle terminal
- `<leader>tn` new terminal
- `<leader>td` toggle dev server terminal
- `<Esc><Esc>` leave terminal mode

## Requirements

At minimum, this config expects:

- Neovim stable or newer
- `git`
- `make`
- a Nerd Font
- `ripgrep`
- `fd`
- `tmux` if using the tmux terminal workflow

Language tooling depends on what you edit. For this setup, that commonly means:

- `node` / `npm` or `pnpm`
- `go`
- `zig`

## If You Want To Change It

The easiest way to extend this config is:

1. add or edit plugin specs in [`lua/lazy/`](/Users/mac/.config/nvim/lua/lazy)
2. keep shared setup in [`lua/config/`](/Users/mac/.config/nvim/lua/config)
3. put custom local behavior in [`lua/custom/`](/Users/mac/.config/nvim/lua/custom)
4. keep per-language LSP changes in [`lsp/`](/Users/mac/.config/nvim/lsp)

That separation is the main reason this config stays understandable.

## Summary

This is my Neovim config: a modular, tmux-friendly, LSP-focused setup built for everyday coding, especially project-based work and frontend/dev-server workflows.

It keeps the core simple, moves custom logic into small local modules, and favors tools that make navigation, diagnostics, terminals, and session management feel fast.
