return {
  "folke/tokyonight.nvim",
  lazy = false, -- Ensures it loads at startup
  priority = 1000, -- High priority for loading
  config = function()
    -- Configure tokyonight BEFORE setting the colorscheme
    require("tokyonight").setup({
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
      },
      sidebars = { "qf", "help" }, -- Optional
    })

    -- Now apply the colorscheme
    vim.cmd("colorscheme tokyonight")
  end,
}
