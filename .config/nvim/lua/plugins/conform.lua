return {
  "stevearc/conform.nvim",
  opts = function()
    return {
      default_format_opts = {
        timeout_ms = 5000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        typescript = { "biome" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        css = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        -- Keep prettier for formats biome doesn't support
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        elixir = { "mix" },
        -- Apply trim_whitespace to ALL file types
        ["*"] = { "trim_whitespace" },
      },
      formatters = {
        biome = {
          command = "biome",
          args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
        },
        prettier = {
          single_quote = true,
          jsx_single_quote = true,
          prepend_args = { "--print-width", "999" },
        },
        injected = { options = { ignore_errors = true } },
      },
    }
  end,
}
