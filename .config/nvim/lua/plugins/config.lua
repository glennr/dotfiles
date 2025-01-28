return {
  {
    "LazyVim/LazyVim",
    priority = 10000,
    opts = {},
    init = function()
      -- Prepend mise shims directory to PATH
      vim.env.PATH = os.getenv("HOME") .. "/.local/share/mise/shims:" .. os.getenv("PATH")
    end,
  },
}