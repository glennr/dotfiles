-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
    },
  },
})

-- Prepend mise shims directory to PATH
vim.env.PATH = os.getenv("HOME") .. "/.local/share/mise/shims:" .. os.getenv("PATH")

local opts = function()
  local plugin = require("lazy.core.config").plugins["conform.nvim"]

  -- Ensure the plugin config is not overridden
  if plugin.config ~= M.setup then
    LazyVim.error({
      "Don't set `plugin.config` for `conform.nvim`.\n",
      "This will break **LazyVim** formatting.\n",
      "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
    }, { title = "LazyVim" })
  end

  ---@type conform.setupOpts
  local opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = "fallback", -- not recommended to change
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      typescript = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
    },
    formatters = {
      prettier = {
        single_quote = true,
        jsx_single_quote = true,
      },
      injected = { options = { ignore_errors = true } },
    },
  }
  return opts
end
