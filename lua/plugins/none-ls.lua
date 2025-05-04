return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting
    local helpers = require "null-ls.helpers"
    local methods = require "null-ls.methods"

    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier',
        'eslint_d',
        'shfmt',
      },
      automatic_installation = true,
    }

    local sources = {
      -- Formatters
      formatting.black.with {
        command = '/data/data/com.termux/files/usr/bin/black',
      },
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.prettier.with { filetypes = { 'html', 'css', 'json', 'yaml', 'markdown' } },

      -- Diagnostics for flake8 (custom defined)
      helpers.make_builtin({
        name = "flake8",
        method = methods.internal.DIAGNOSTICS,
        filetypes = { "python" },
        generator_opts = {
          command = "/data/data/com.termux/files/usr/bin/flake8",
          args = { "--format=%(row)d:%(col)d:%(code)s:%(text)s", "-" },
          to_stdin = true,
          from_stderr = false,
          format = "line",
          check_exit_code = function(code) return code <= 1 end,
          on_output = function(line)
            local row, col, code, msg = line:match("^(%d+):(%d+):([%w]+):(.+)$")
            return {
              row = tonumber(row),
              col = tonumber(col),
              code = code,
              message = msg,
              severity = helpers.diagnostics.severities.warning,
              source = "flake8",
            }
          end,
        },
        factory = helpers.generator_factory,
      }),

      -- Diagnostics for luacheck (custom defined)
      helpers.make_builtin({
        name = "luacheck",
        method = methods.internal.DIAGNOSTICS,
        filetypes = { "lua" },
        generator_opts = {
          command = "/data/data/com.termux/files/usr/bin/luacheck",
          args = { "--formatter", "plain", "--codes", "--ranges", "--filename", "$FILENAME", "-" },
          to_stdin = true,
          from_stderr = false,
          format = "line",
          check_exit_code = function(code) return code <= 1 end,
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

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
  end,
}
