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

  -- :A jumps between lib/x.ex and test/x_test.exs in any Mix project, falling
  -- back to the folder's test, as a LiveView's foo_live/*.ex share foo_live_test.exs.
  {
    "tpope/vim-projectionist",
    lazy = false,
    init = function()
      vim.g.projectionist_heuristics = {
        ["mix.exs"] = {
          ["lib/*.ex"] = {
            type = "source",
            alternate = { "test/{}_test.exs", "test/{dirname}_test.exs" },
          },
          ["test/*_test.exs"] = { type = "test", alternate = { "lib/{}.ex", "lib/{}/index.ex" } },
        },
      }
    end,
  },
}
