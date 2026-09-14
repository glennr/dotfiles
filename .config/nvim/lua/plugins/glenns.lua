return {
  -- LazyVim extras, declared here instead of in the generated lazyvim.json
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.typescript" },

  { "chaoren/vim-wordmotion" },
  {
    "nvim-neo-tree/neo-tree.nvim",

    opts = {
      filesystem = {
        bind_to_cwd = true,
      },
    },
  },
  {
    "jremmen/vim-ripgrep",
    lazy = false,
    keys = {
      { "<leader>a", ":Rg ", desc = "Ripgrep search" },
    },
  },
}
