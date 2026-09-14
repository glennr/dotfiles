vim.opt.autochdir = false -- Disable auto-changing directory

-- Override LazyVim's root directory detection
vim.g.root_spec = { { "git" }, { "lua" }, "global" }

-- Prepend mise's shim path so LSPs (and anything else) see those binaries first
vim.env.PATH = vim.fn.expand("~/.local/share/mise/shims") .. ":" .. vim.env.PATH
