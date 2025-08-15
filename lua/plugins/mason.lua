if true then
  return {}
end

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local util = require("lspconfig.util")

      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = {
          "pyright",
          "ts_ls",
          "html",
          "cssls",
          "yamlls",
          "jsonls",
        },
        automatic_installation = false, -- avoid duplicate servers
      })

      -- Common on_attach
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          opts
        )
      end

      -- Server configs
      local servers = {
        pyright = {
          filetypes = { "python" },
          root_dir = util.root_pattern(
            "pyproject.toml",
            "setup.py",
            "requirements.txt",
            ".git"
          ),
        },
        ts_ls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = util.root_pattern(
            "package.json",
            "tsconfig.json",
            "jsconfig.json",
            ".git"
          ),
        },
        html = {
          filetypes = { "html" },
          root_dir = util.root_pattern(".git", "*.html"),
        },
        cssls = {
          filetypes = { "css", "scss", "less" },
          root_dir = util.root_pattern(".git", "*.css"),
        },
        yamlls = {
          filetypes = { "yaml", "yml" },
          root_dir = util.root_pattern(".git", "*.yml", "*.yaml"),
        },
        jsonls = {
          filetypes = { "json", "jsonc" },
          root_dir = util.root_pattern(".git", "*.json"),
        },
        lua_ls = {
          filetypes = { "lua" },
          cmd = { "/data/data/com.termux/files/usr/bin/lua-language-server" }, -- Termux binary
          root_dir = util.root_pattern(".git", "*.lua"),
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
      }

      -- Setup all servers
      for name, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[name].setup(config)
      end
    end,
  },
}
