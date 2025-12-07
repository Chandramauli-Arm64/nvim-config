local wk = require("which-key")
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>h", ":nohlsearch<CR>", opts)
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
map("n", "<leader>Lg", "<cmd>Lazygit<CR>", opts)

wk.add({
  {
    "<leader>h",
    ":nohlsearch<CR>",
    desc = "Clear search highlight",
    mode = "n",
  },
  -- Navigation
  { "j", "gj", desc = "Down (wrapped line)", mode = "n" },
  { "k", "gk", desc = "Up (wrapped line)", mode = "n" },
  -- File explorer
  {
    "<leader>e",
    "<cmd>NvimTreeToggle<CR>",
    desc = "Toggle file explorer",
    mode = "n",
  },
  -- Lazygit
  {
    "<leader>lg",
    "<cmd>Lazygit<CR>",
    desc = "Open Lazygit in floating terminal",
    mode = "n",
  },
})
