return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,      -- Better command-line search UI
        command_palette = true,    -- Cmdline and popup UI combo
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    })

    -- Optional: setup notify UI
    require("notify").setup({
      background_colour = "#1A1B26", -- Match your theme
      render = "minimal",
      stages = "slide",
      timeout = 3000,
    })

    vim.notify = require("notify")
  end,
}
