-- Move selected lines and keep the selection active.
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move Selected Lines Down", silent = true })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move Selected Lines Up", silent = true })

-- Use hjkl for navigation instead of the arrow keys.
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  vim.keymap.set({ "n", "i", "v", "o", "c", "t" }, key, "<Nop>")
end
