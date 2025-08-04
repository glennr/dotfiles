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
        elixir = { "mix" },
        -- Apply trim_whitespace to ALL file types
        ["*"] = { "trim_whitespace" },
      },
      formatters = {
        prettier = {
          single_quote = true,
          jsx_single_quote = true,
        },
        injected = { options = { ignore_errors = true } },
      },
    }
  end,
}
