return {
  "olimorris/onedarkpro.nvim",
  priority = 1000, -- Ensure it loads before other plugins
  config = function()
    require("onedarkpro").setup({
      colors = {}, -- keep defaults
      highlights = {}, -- keep defaults

      -- Disable all italics/bold/underline
      styles = {
        types = "NONE",
        methods = "NONE",
        numbers = "NONE",
        strings = "NONE",
        comments = "NONE",
        keywords = "NONE",
        constants = "NONE",
        functions = "NONE",
        operators = "NONE",
        variables = "NONE",
        parameters = "NONE",
        conditionals = "NONE",
        virtual_text = "NONE",
      },

      filetypes = {
        c = true,
        comment = true,
        go = true,
        html = true,
        java = true,
        javascript = true,
        json = true,
        latex = true,
        lua = true,
        markdown = true,
        php = true,
        python = true,
        ruby = true,
        rust = true,
        scss = true,
        toml = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        xml = true,
        yaml = true,
      },

      plugins = {
        aerial = true,
        barbar = true,
        blink_cmp = true,
        codecompanion = true,
        copilot = true,
        dashboard = true,
        flash_nvim = true,
        gitgraph_nvim = true,
        gitsigns = true,
        hop = true,
        indentline = true,
        leap = true,
        lsp_saga = true,
        lsp_semantic_tokens = true,
        marks = true,
        mini_diff = true,
        mini_icons = true,
        mini_indentscope = true,
        mini_test = true,
        neotest = true,
        neo_tree = true,
        nvim_cmp = true,
        nvim_bqf = true,
        nvim_dap = true,
        nvim_dap_ui = true,
        nvim_hlslens = true,
        nvim_lsp = true,
        nvim_navic = true,
        nvim_notify = true,
        nvim_tree = true,
        nvim_ts_rainbow = true,
        op_nvim = true,
        packer = true,
        persisted = true,
        polygot = true,
        rainbow_delimiters = true,
        render_markdown = true,
        startify = true,
        telescope = true,
        toggleterm = true,
        treesitter = true,
        trouble = true,
        vim_ultest = true,
        which_key = true,
        vim_dadbod_ui = true,
      },

      options = {
        cursorline = true, -- highlight current line
        transparency = false, -- solid background
        terminal_colors = true,
        lualine_transparency = false,
        highlight_inactive_windows = false,
      },
    })

    -- Apply the dark variant
    vim.cmd("colorscheme onedark_dark")
  end,
}
