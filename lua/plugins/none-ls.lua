if true then
  return {}
end

-- ~/.config/nvim/lua/plugins/none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "jayp0521/mason-null-ls.nvim",
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local null_ls = require("null-ls")
    local lspconfig = require("lspconfig")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local helpers = require("null-ls.helpers")
    local methods = require("null-ls.methods")

    -- Capabilities for LSP
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Mason Null-LS Setup (no Ruff here, handled by LSP)
    require("mason-null-ls").setup({
      ensure_installed = {
        "prettier",
        "eslint_d",
        "shfmt",
      },
      automatic_installation = true,
    })

    -- Null-LS Sources
    local sources = {
      -- Python
      formatting.black.with({
        command = "/data/data/com.termux/files/usr/bin/black",
      }),

      -- JavaScript / TypeScript / Web
      formatting.prettier.with({
        filetypes = {
          "html",
          "css",
          "json",
          "yaml",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      }),

      -- Shell
      formatting.shfmt.with({ args = { "-i", "4" } }),

      -- Lua
      formatting.stylua.with({
        command = "/data/data/com.termux/files/usr/bin/stylua",
        filetypes = { "lua" },
      }),

      -- Luacheck diagnostics
      helpers.make_builtin({
        name = "luacheck",
        method = methods.internal.DIAGNOSTICS,
        filetypes = { "lua" },
        generator_opts = {
          command = "/data/data/com.termux/files/usr/bin/luacheck",
          args = {
            "--formatter",
            "plain",
            "--codes",
            "--ranges",
            "--filename",
            "$FILENAME",
            "-",
          },
          to_stdin = true,
          from_stderr = false,
          format = "line",
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(line)
            local row, col, msg = line:match("^(%d+):(%d+): (.+)$")
            if row and col and msg then
              return {
                row = tonumber(row),
                col = tonumber(col),
                message = msg,
                severity = helpers.diagnostics.severities.warning,
                source = "luacheck",
              }
            end
          end,
        },
        factory = helpers.generator_factory,
      }),
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
    -- LSP: Pyright with Ruff
    lspconfig.pyright.setup({
      capabilities = capabilities,
      settings = {
        pyright = {
          disableOrganizeImports = true, -- Let Ruff handle imports
        },
        python = {
          analysis = {
            ignore = { "*" }, -- Only Ruff handles linting
          },
        },
      },
    })

    lspconfig.ruff.setup({
      capabilities = capabilities,
    })
  end,
}
