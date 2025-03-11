return {
  {
    "LazyVim/LazyVim",
    priority = 10000,
    opts = {},
    init = function()
      -- use mise global config
      --vim.env.MISE_GLOBAL_CONFIG_FILE = vim.fn.expand("$HOME") .. "/.config/mise/config.toml"

      -- Prepend mise shims directory to PATH
      -- vim.env.PATH = os.getenv("HOME") .. "/.local/share/mise/shims:" .. os.getenv("PATH")
    end,
  },
}
