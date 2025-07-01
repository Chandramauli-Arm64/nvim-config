return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { "markdown" },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    render_on_start = false, -- Prevent lag on load
  },
  keys = {
    { "<leader>mr", function() require("render-markdown").toggle() end, desc = "Toggle Render Markdown" },
  },
}
