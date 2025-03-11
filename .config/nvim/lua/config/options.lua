-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.autochdir = false -- Disable auto-changing directory

-- Override LazyVim's root directory detection
vim.g.root_spec = { { "git" }, { "lua" }, "global" }

-- Adjust to wherever Mise actually installs its shims:
local mise_shim_path = vim.fn.expand("~/.local/share/mise/shims")

-- Prepend the shim path so LSPs (and anything else) see those binaries first:
vim.env.PATH = mise_shim_path .. ":" .. vim.env.PATH
