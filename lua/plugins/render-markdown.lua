return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim", -- for icons (lighter than nvim-web-devicons)
  },
  ft = { "markdown", "quarto", "mdx" }, -- load only for note files
  opts = {
    enabled = true, -- auto render
    debounce = 150, -- balance performance in Termux
    anti_conceal = { -- keep text visible near cursor
      enabled = true,
      above = 1,
      below = 1,
    },
  },
  keys = {
    {
      "<leader>mr",
      function()
        require("render-markdown").toggle()
      end,
      desc = "Toggle Markdown Rendering",
    },
  },
}
