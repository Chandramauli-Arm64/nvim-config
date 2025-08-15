return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
        buffers = {
          initial_mode = "normal",
          mappings = {
            n = { ["d"] = actions.delete_buffer },
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Load extensions
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- Mobile-friendly keymaps
    vim.keymap.set("n", "ff", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "bb", builtin.buffers, { desc = "Find Buffers" })
    vim.keymap.set("n", "gg", builtin.git_files, { desc = "Find Git Files" })
    vim.keymap.set("n", "ll", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "hh", builtin.help_tags, { desc = "Help Tags" })
    vim.keymap.set("n", "ss", function()
      builtin.lsp_document_symbols({
        symbols = { "Class", "Function", "Method", "Constructor" },
      })
    end, { desc = "LSP Symbols" })
    vim.keymap.set(
      "n",
      "sd",
      builtin.diagnostics,
      { desc = "Search Diagnostics" }
    )
    vim.keymap.set("n", "rr", builtin.resume, { desc = "Resume Last Search" })
  end,
}
