return {
  "folke/tokyonight.nvim",
  lazy = false, -- Ensures it loads at startup
  priority = 1000, -- High priority for loading
  config = function()
    vim.cmd("colorscheme tokyonight") -- Set the colorscheme
  end,
}
