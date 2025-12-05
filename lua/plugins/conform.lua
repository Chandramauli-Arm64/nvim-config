return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- load just before saving
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },

  ---@diagnostic disable-next-line: undefined-doc-name
  ---@type conform.setupOpts
  opts = {
    -- Easy to edit formatter mapping
    formatters_by_ft = {
      lua = { "stylua" },
      python = function(bufnr)
        local conform = require("conform")
        if conform.get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_format", "black" }
        else
          return { "ruff", "black" }
        end
      end,
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "jq" },
      yaml = { "prettier" },
      ["*"] = { "codespell" }, -- apply everywhere
      ["_"] = { "trim_whitespace" }, -- fallback
      cpp = { "clang-format" },
      c = { "clang-format" },
      perl = { "perltidy" },
      sql = { "sql-formatter" },
    },

    -- Unified formatting options
    default_format_opts = {
      lsp_format = "fallback", -- use LSP if no formatter is set
      timeout_ms = 3000, -- give prettier/others time to finish
      async = true, -- never block your typing
    },

    -- Auto-format on save
    format_on_save = function(bufnr)
      -- disable for very large files
      if vim.api.nvim_buf_line_count(bufnr) > 5000 then
        return
      end
      return { timeout_ms = 3000, lsp_format = "fallback" }
    end,

    -- Custom overrides (easy to extend)
    formatters = {
      prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
        cwd = function()
          return vim.fn.getcwd()
        end,
      },
      sql_formatter = {
        command = "sql-formatter",
        args = { "--language", "mysql" },
        stdin = true,
      },
    },

    -- Minimal notifications
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    notify_no_formatters = true,
  },

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
