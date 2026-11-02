return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "main",
      -- Let Ghostty's background and opacity show through.
      styles = { transparency = true },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "rose-pine" },
  },
}
