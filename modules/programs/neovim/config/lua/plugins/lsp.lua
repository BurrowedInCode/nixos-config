return {
  -- Nix supplies language servers and formatters instead of Mason downloads.
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          mason = false,
          settings = {
            gopls = {
              buildFlags = { "-tags=integration" },
            },
          },
        },
        nixd = { mason = false },
        rust_analyzer = { mason = false },
        lua_ls = { mason = false },
        ts_ls = { mason = false },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofmt" },
        rust = { "rustfmt" },
        nix = { "nixfmt" },
        lua = { "stylua" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },
}
