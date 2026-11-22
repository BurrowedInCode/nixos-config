-- Move selected lines and keep the selection active.
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move Selected Lines Down", silent = true })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move Selected Lines Up", silent = true })

-- Reorder buffer tabs and native tab pages.
vim.keymap.set("n", "<leader>bH", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Left", silent = true })
vim.keymap.set("n", "<leader>bL", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Right", silent = true })
vim.keymap.set("n", "<leader><tab>H", "<cmd>tabmove -1<cr>", { desc = "Move Tab Left", silent = true })
vim.keymap.set("n", "<leader><tab>L", "<cmd>tabmove +1<cr>", { desc = "Move Tab Right", silent = true })

-- Use hjkl for navigation instead of the arrow keys.
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  vim.keymap.set({ "n", "i", "v", "o", "c", "t" }, key, "<Nop>")
end
