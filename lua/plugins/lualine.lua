-- File: lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "linrongbin16/lsp-progress.nvim",
  },
  config = function()
    local ok, lualine = pcall(require, "lualine")
    if not ok then
      return
    end

    local colors = {
      bg = "#1e1e2e",
      fg = "#cdd6f4",
      yellow = "#f9e2af",
      cyan = "#94e2d5",
      darkblue = "#89b4fa",
      green = "#a6e3a1",
      orange = "#fab387",
      violet = "#cba6f7",
      magenta = "#f5c2e7",
      blue = "#89b4fa",
      red = "#f38ba8",
    }

    local catppuccin_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = { a = { bg = colors.green, fg = colors.bg, gui = "bold" } },
      visual = { a = { bg = colors.magenta, fg = colors.bg, gui = "bold" } },
      replace = { a = { bg = colors.red, fg = colors.bg, gui = "bold" } },
      command = { a = { bg = colors.yellow, fg = colors.bg, gui = "bold" } },
      inactive = {
        a = { bg = colors.bg, fg = colors.fg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
    }

    lualine.setup({
      options = {
        theme = catppuccin_theme,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "NvimTree", "lazy" } },
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = " ●",
              readonly = " 󰌾",
              unnamed = "[No Name]",
            },
          },
          {
            function()
              return require("lsp-progress").progress()
            end,
          },
        },
        lualine_x = {
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = colors.green },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { { "location", icon = "" } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "nvim-tree", "fugitive", "toggleterm" },
    })

    -- refresh lualine when LSP progress updates
    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "lualine_augroup",
      pattern = "LspProgressStatusUpdated",
      callback = require("lualine").refresh,
    })
  end,
}
