local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Better navigation in wrapped lines
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Fast exit insert mode (useful for phone typing)
map("i", "jj", "<Esc>", opts)

-- Toggle nvim-tree (normal window)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)

-- Open nvim-tree in floating window
map("n", "<leader>f", function()
  require("nvim-tree.api").tree.toggle({
    view = {
      float = {
        enable = true,
        quit_on_focus_loss = true,
      },
    },
  })
end, opts)
