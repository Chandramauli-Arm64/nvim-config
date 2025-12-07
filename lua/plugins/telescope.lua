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
    ---@diagnostic disable-next-line: unused-local
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
    vim.keymap.set(
      "n",
      "<leader>ff",
      builtin.find_files,
      { desc = "Find Files" }
    )
    vim.keymap.set(
      "n",
      "<leader>bb",
      builtin.buffers,
      { desc = "Find Buffers" }
    )
    vim.keymap.set(
      "n",
      "<leader>gg",
      builtin.git_files,
      { desc = "Find Git Files" }
    )
    vim.keymap.set("n", "<leader>Lg", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>ht", builtin.help_tags, { desc = "Help Tags" })
    vim.keymap.set("n", "<leader>ss", function()
      builtin.lsp_document_symbols({
        symbols = { "Class", "Function", "Method", "Constructor" },
      })
    end, { desc = "LSP Symbols" })
    vim.keymap.set(
      "n",
      "<leader>sd",
      builtin.diagnostics,
      { desc = "Search Diagnostics" }
    )
    vim.keymap.set(
      "n",
      "<leader>rr",
      builtin.resume,
      { desc = "Resume Last Search" }
    )
  end,

  init = function()
    local wk = require("which-key")

    wk.add({
      -- Group for Telescope searches
      { "f", group = "Find/Search", mode = "n" },

      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>bb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find Buffers",
      },
      {
        "<leader>gg",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>Lg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>ht",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help Tags",
      },

      -- LSP-specific searches
      { "s", group = "Search (LSP)", mode = "n" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = { "Class", "Function", "Method", "Constructor" },
          })
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sd",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Search Diagnostics",
      },

      -- Resume last search
      {
        "<leader>rr",
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Resume Last Search",
      },
    })
  end,
}
