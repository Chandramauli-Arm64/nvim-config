return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- lazy load before saving buffer
  cmd = { "ConformInfo" }, -- load when running :ConformInfo
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = "", -- works in normal/visual
      desc = "Format buffer",
    },
  },
  ---@module "conform"
  ---@diagnostic disable-next-line: undefined-doc-name
  ---@type conform.setupOpts
  opts = {
    -- Map filetypes to formatters
    formatters_by_ft = {
      lua = { "stylua" }, -- system stylua
      python = function(bufnr)
        -- Prefer ruff_format if available, else run ruff + black
        if
          require("conform").get_formatter_info("ruff_format", bufnr).available
        then
          return { "ruff_format", "black" }
        else
          return { "ruff", "black" }
        end
      end,
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "jq" },
      ["*"] = { "codespell" }, -- run on all filetypes
      ["_"] = { "trim_whitespace" }, -- fallback
    },

    -- Default options for formatting
    default_format_opts = {
      lsp_format = "fallback", -- fallback to LSP if no formatter
    },

    -- Format on save (synchronous, short timeout)
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },

    -- Also support async formatting after save
    format_after_save = {
      lsp_format = "fallback",
    },

    -- Logging & notifications
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    notify_no_formatters = true,

    -- Custom formatters / overrides
    formatters = {
      prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
        cwd = function()
          return vim.fn.getcwd()
        end,
        require_cwd = false,
      },
    },
  },
  init = function()
    -- If you want Conform as the default formatexpr
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
