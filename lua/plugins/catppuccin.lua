return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Make sure it's loaded first
  lazy = false, -- Load on startup
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false, -- Show the ~ characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "bold" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = {
          enabled = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "bold" },
            hints = { "bold" },
            warnings = { "bold" },
            information = { "bold" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        indent_blankline = {
          enabled = true,
          scope_color = "lavender",
          colored_indent_levels = false,
        },
        illuminate = true,
        mason = true,
        which_key = true,
        noice = false,
        notify = true,
        mini = false,
        leap = true,
        dashboard = false,
      },
    })

    -- Set colorscheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
