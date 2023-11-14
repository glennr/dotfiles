-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.format_on_save = {
  enabled = true,
  -- pattern = "*.tex,*.bib",
  timeout = 5000
}
-- increase timeout so mix format doesnt fail
lvim.builtin.which_key.mappings["l"]["f"] = {
  function()
    require("lvim.lsp.utils").format { timeout_ms = 5000 }
  end,
  "Format",
}
lvim.lsp.null_ls.setup.timeout_ms = 5000

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "mix", filetypes = { "elixir", "heex", "html-eex" } },
  {
    name = "rustywind",
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "html", "elixir",
      "heex",
      "html-eex"
    }
  },
  {
    name = "prettier",
    --     ---@usage arguments to pass to the formatter
    --     -- these cannot contain whitespace
    --     -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    --     args = { "--print-width", "100" },
    --     ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    --     filetypes = { "typescript", "typescriptreact" },
  },
}

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "sqlfluff" },
  { name = "credo" }
  --   { command = "flake8", filetypes = { "python" } },
  --   {
  --     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --     command = "shellcheck",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     extra_args = { "--severity", "warning" },
  --   },
  --   {
  --     command = "codespell",
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "javascript", "python" },
  --   },
}


lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "elixir",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- Additional Plugins
lvim.plugins = {
  {
    -- "folke/trouble.nvim",
    -- cmd = "TroubleToggle",
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  { "chaoren/vim-wordmotion" },
  -- disabling this since I use the CLI mostly, and it interferes with gotot commands like g-d
  --  { "tpope/vim-fugitive" },
  { 'cloudhead/neovim-fuzzy' },
  { 'jremmen/vim-ripgrep' },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
    lazy = false,
  },
  {
    'laytan/tailwind-sorter.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
    build = 'cd formatter && npm i && npm run build',
    config = true,
  }
}

-- runs eslint --fix on save
-- TODO: Use prettier_eslint instead?
require 'lspconfig'.eslint.setup({
  settings = {
    packageManager = 'npm'
  },
  on_attach = function(_client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

require('tailwind-sorter').setup({
  on_save_enabled = true, -- If `true`, automatically enables on save sorting.
  on_save_pattern = {
    '*.html',
    '*.js',
    '*.jsx',
    '*.tsx',
    '*.twig',
    '*.hbs',
    '*.php',
    '*.ex',
    '*.eex',
    '*.heex',
    '*.astro'
  }, -- The file patterns to watch and sort.
  node_path = 'node',
})

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-p>"] = ":FuzzyOpen<CR>"

-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false

-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

--- --- Use Ripgrep
---  Usage - search and replace in all files
---   :Rg <search-term>
---   :cfdo %s/match/pattern/ge | update
---
-- noremap <leader>a :Rg<space>
lvim.keys.normal_mode["<leader>a"] = ":Rg<space>"

-- Strip whitespace all files on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}
