return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night", -- "storm", "night", or "day"
    light_style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
      functions = {},
      variables = {},
      sidebars = "dark",
      floats = "dark",
    },
    day_brightness = 0.3,
    dim_inactive = false,
    lualine_bold = false,
    -- You can override specific color groups or highlights
    ---@diagnostic disable-next-line: unused-local
    on_colors = function(colors) end,
    ---@diagnostic disable-next-line: unused-local
    on_highlights = function(highlights, colors) end,
    cache = true,
    plugins = {
      all = package.loaded.lazy == nil,
      auto = true,
      -- Add more plugin options here as needed
      -- telescope = true,
    },
  },
}
