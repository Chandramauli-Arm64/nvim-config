return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP (Defs/Refs/...)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
  opts = {
    auto_open = false, -- don’t pop up on its own
    auto_close = true, -- closes when empty
    auto_preview = false, -- previews are heavy on phone, disable
    auto_refresh = true,
    focus = false,
    restore = true,
    follow = false, -- avoids cursor auto-jumps
    indent_guides = false, -- cleaner UI on small screen
    max_items = 150, -- lighter than default 200
    multiline = true,
    warn_no_results = true,
    preview = { type = "split", scratch = true }, -- split preview safer than floating on Termux
    throttle = {
      refresh = 50, -- less CPU stress
      update = 30,
      render = 30,
      follow = 150,
      preview = { ms = 200, debounce = true },
    },
    icons = {
      indent = {
        top = "│ ",
        middle = "├─",
        last = "└─",
        fold_open = " ",
        fold_closed = " ",
        ws = "  ",
      },
      folder_closed = " ",
      folder_open = " ",
      kinds = {
        Class = " ",
        Constructor = " ",
        Enum = " ",
        Field = " ",
        Function = "󰊕 ",
        Interface = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Property = " ",
        Struct = "󰆼 ",
        Variable = "󰀫 ",
      },
    },
  },

  init = function()
    local wk = require("which-key")

    wk.add({
      -- Main Trouble group under <leader>x
      { "<leader>x", group = "Trouble" },

      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List",
      },

      -- LSP-related trouble commands under <leader>c
      { "<leader>c", group = "Code" },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP (Defs/Refs/...)",
      },
    })
  end,
}
