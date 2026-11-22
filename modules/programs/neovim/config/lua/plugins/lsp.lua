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
        prismals = {
          mason = false,
          cmd = function(dispatchers, config)
            local root = config.root_dir or vim.fn.getcwd()
            local directory = root
            while directory do
              local prisma_dir = directory .. "/node_modules/prisma"
              local manifest = prisma_dir .. "/package.json"
              if vim.fn.filereadable(manifest) == 1 then
                local prisma = vim.json.decode(table.concat(vim.fn.readfile(manifest), "\n"))
                local major = tonumber((prisma.version or ""):match("^(%d+)"))
                if major and major >= 8 then
                  -- Prisma 8 contracts use the project's CLI, not the legacy schema server.
                  return vim.lsp.rpc.start({ "node", prisma_dir .. "/dist/prisma.js", "lsp", "--stdio" }, dispatchers, {
                    cwd = root,
                  })
                end
                break
              end
              local parent = vim.fs.dirname(directory)
              directory = parent ~= directory and parent or nil
            end
            return vim.lsp.rpc.start({ "prisma-language-server", "--stdio" }, dispatchers, { cwd = root })
          end,
        },
        bashls = { mason = false },
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
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },
}
