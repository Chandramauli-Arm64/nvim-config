return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      lua = { "luacheck" },
      python = { "ruff" }, -- Fast Python linter; use "flake8" or "pylint" if preferred
      javascript = { "eslint_d" }, -- Fast JS linter; use "eslint" if "eslint_d" unavailable
      typescript = { "eslint_d" },
      css = { "stylelint" },
      json = { "jsonlint" },
      -- markdown   = { "markdownlint" },
      -- sh         = { "shellcheck" },
      yaml = { "yamllint" },
      -- Add additional mappings as needed
    }

    -- Optional: You can configure arguments for linters if needed
    lint.linters.eslint_d = lint.linters.eslint_d or {}
    lint.linters.eslint_d.args = { "--format", "json" }
    lint.linters.flake8 = lint.linters.flake8 or {}
    lint.linters.flake8.args = { "--format=default" }

    -- Automatically lint on buffer write or when leaving insert mode
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })

    -- Manual linter command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Run linter for current buffer" })
  end,
}
