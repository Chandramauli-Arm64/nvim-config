return {
  "2kabhishek/nerdy.nvim",
  dependencies = {
    "folke/snacks.nvim",
    "nvim-telescope/telescope.nvim", -- You need Telescope too!
  },
  cmd = { "Nerdy" }, -- Lazy load only when you run :Nerdy
  config = function()
    require("telescope").load_extension("nerdy")
  end,
}
