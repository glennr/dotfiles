return {
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
