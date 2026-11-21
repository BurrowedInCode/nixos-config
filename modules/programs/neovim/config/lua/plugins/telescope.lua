return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require("telescope.actions")

      -- Search hidden project files, but respect ignore files and skip Git internals.
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/**",
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
          },
        },
      })

      -- Telescope's buffer-local mappings would otherwise override the global restrictions.
      for _, mode in ipairs({ "i", "n" }) do
        opts.defaults.mappings[mode] = opts.defaults.mappings[mode] or {}
        for _, key in ipairs({
          "<Up>",
          "<Down>",
          "<Left>",
          "<Right>",
          "<C-Up>",
          "<C-Down>",
          "<LeftMouse>",
          "<2-LeftMouse>",
          "<ScrollWheelUp>",
          "<ScrollWheelDown>",
          "<ScrollWheelLeft>",
          "<ScrollWheelRight>",
        }) do
          opts.defaults.mappings[mode][key] = actions.nop
        end
      end
    end,
  },
}
