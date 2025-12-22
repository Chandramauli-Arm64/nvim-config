return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "VeryLazy" },
  ---@module "ibl"
  ---@diagnostic disable-next-line: undefined-doc-name
  ---@type ibl.config
  opts = {
    -- Character for indentation
    indent = {
      char = "▏",
    },

    -- Current scope highlight
    scope = {
      enabled = true,
      show_start = true, -- glow at the start of scope
      show_end = false, -- don't highlight end
      show_exact_scope = false, -- only current scope
    },

    -- Exclude certain filetypes
    exclude = {
      filetypes = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "Trouble",
      },
    },
  },
}
