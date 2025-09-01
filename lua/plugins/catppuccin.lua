return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "auto",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      float = {
        transparent = false,
        solid = false,
      },
      show_end_of_buffer = false,
      term_colors = true,

      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.12,
      },

      no_italic = false,
      no_bold = false,
      no_underline = true,

      styles = {
        comments = { "italic" },
        conditionals = { "bold" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = { "bold" },
        operators = {},
      },

      color_overrides = {
        mocha = {
          base = "#1E1E2E",
          mantle = "#181825",
          crust = "#11111b",
        },
      },

      custom_highlights = function(colors)
        return {
          FloatBorder = { fg = colors.lavender, bg = colors.base },
          NormalFloat = { bg = colors.base },

          TelescopeBorder = { fg = colors.lavender, bg = colors.base },
          TelescopeNormal = { bg = colors.base },
          TelescopeSelection = {
            bg = colors.surface0,
            fg = colors.text,
            bold = true,
          },

          Pmenu = { bg = colors.mantle, fg = colors.text },
          PmenuSel = { bg = colors.surface1, fg = colors.lavender, bold = true },
          PmenuBorder = { fg = colors.lavender },

          Visual = { bg = colors.surface1 },

          DiagnosticError = { fg = colors.red },
          DiagnosticWarn = { fg = colors.yellow },
          DiagnosticInfo = { fg = colors.sky },
          DiagnosticHint = { fg = colors.teal },
        }
      end,

      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = { enabled = true },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = { background = false },
        },
        indent_blankline = {
          enabled = true,
          scope_color = "lavender",
          colored_indent_levels = false,
        },
        illuminate = true,
        which_key = true,
        notify = true,
        leap = true,
        mini = false,
        fzf = true,
      },
    })

    -- Sync with terminal background (light/dark)
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = function()
        vim.cmd.colorscheme("catppuccin")
      end,
    })

    -- Set colorscheme initially
    vim.cmd.colorscheme("catppuccin")
  end,
}
