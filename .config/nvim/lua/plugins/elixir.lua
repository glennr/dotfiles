-- Elixir/Phoenix: extras imported here so yadm carries them (lazyvim.json is untracked).
return {
  { import = "lazyvim.plugins.extras.lang.elixir" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.test.core" },

  -- Expert, the official Elixir LSP, in place of the extra's ElixirLS.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        elixirls = { enabled = false },
        expert = {},
      },
    },
  },
}
