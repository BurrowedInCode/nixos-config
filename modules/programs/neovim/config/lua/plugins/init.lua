return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open Parent Directory" },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>td",
        function()
          Snacks.terminal("lazydocker", { win = { style = "float" } })
        end,
        desc = "Lazydocker",
      },
    },
  },
}
