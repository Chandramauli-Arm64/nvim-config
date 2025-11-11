-- Diagnostic configuration (icons + clean UI)
vim.diagnostic.config({
  virtual_text = true,
  float = { border = "rounded" },
  underline = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- Attach function (runs when LSP attaches to buffer)
local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- Core navigation
  bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  bufmap("n", "gr", vim.lsp.buf.references, "Find References")
  bufmap("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, "Hover Docs")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  bufmap("n", "ca", vim.lsp.buf.code_action, "Code Action")
  bufmap("n", "<leader>sh", function()
    vim.lsp.buf.signature_help({ border = "rounded" })
  end, "Signature Help")

  -- Diagnostics navigation (Neovim 0.11+)
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { buffer = bufnr, desc = "Prev Diagnostic" })
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { buffer = bufnr, desc = "Next Diagnostic" })
  bufmap("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")

  -- Symbols navigation
  bufmap("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols")
  bufmap("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
end

-- Capabilities (for better completion)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

-- Function to start a server
local function start_server(cmd, filetypes, settings)
  if vim.fn.executable(cmd[1]) == 1 then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      ---@diagnostic disable-next-line: unused-local
      callback = function(args)
        vim.lsp.start({
          name = cmd[1],
          cmd = cmd,
          root_dir = vim.fs.dirname(
            vim.fs.find(
              { "init.lua", "package.json", ".git", ".luarc.json", ".root" },
              { upward = true }
            )[1]
          ),
          on_attach = on_attach,
          capabilities = capabilities,
          flags = { debounce_text_changes = 50, exit_timeout = 500 },
          settings = settings,
        })
      end,
    })
  end
end

-- Configure servers (system binaries only)
start_server({ "lua-language-server" }, { "lua" }, {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      format = { enable = true },
      hint = { enable = true },
      telemetry = { enable = false },
    },
  },
})

start_server({ "clangd" }, { "c", "cpp", "objc", "objcpp" }, {
  clangd = {
    completion = { enableSnippets = true },
    inlayHints = { enable = true },
    formatting = { style = "file" },
    diagnostics = { enable = true },
    semanticHighlighting = true,
  },
})

-- start_server({ "yaml-language-server", "--stdio" }, { "yaml" }, {
--  yaml = {
--   schemas = { kubernetes = "/*.k8s.yaml" },
---   completion = true,
---   hover = true,
--   validate = true,
--   format = { enable = false },
-- },
--- })

start_server(
  { "typescript-language-server", "--stdio" },
  { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        completeFunctionCalls = true,
        completePropertyImports = true,
        autoImports = true,
      },
      format = { enable = false },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        completeFunctionCalls = true,
        completePropertyImports = true,
        autoImports = true,
      },
      format = { enable = false },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
    },
  }
)

start_server({ "pyright-langserver", "--stdio" }, { "python" }, {
  python = {
    analysis = {
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      diagnosticMode = "workspace",
      typeCheckingMode = "basic",
      reportMissingTypeStubs = false,
      inlayHints = {
        variableTypes = true,
        functionReturnTypes = true,
        callArgumentTypes = true,
      },
    },
  },
})

start_server(
  { "tclsh", "/data/data/com.termux/files/home/lsp/lsp_server.tcl" },
  { "tcl" },
  {
    tcl = {
      diagnostics = true,
      completion = true,
      hover = true,
    },
  }
)

start_server({
  "/data/data/com.termux/files/usr/bin/vscode-css-language-server",
  "--stdio",
}, { "css", "scss", "less" }, {
  css = {
    validate = true, -- Enable syntax and lint validation
    lint = {
      unknownAtRules = "warning", -- Warn about unknown @ rules
      boxModel = "warning", -- Warn about box model issues
      duplicateProperties = "warning",
      emptyRules = "warning",
      important = "warning",
      shorthandProperties = "warning",
      vendorPrefix = "warning",
      zeroUnits = "warning",
    },
    completion = {
      completePropertyWithSemicolon = true,
      triggerPropertyValueCompletion = true,
    },
    hover = true, -- Enable hover documentation
    colorProvider = true, -- Enable color highlighting
    format = {
      enable = true, -- Enable formatting
    },
    -- You can add custom data paths or css modules if needed:
    -- customData = { "/path/to/your/custom-data.json" },
    -- cssModules = { enable = true },
  },
  scss = {
    validate = true,
    lint = {
      unknownAtRules = "warning",
      boxModel = "warning",
      duplicateProperties = "warning",
      emptyRules = "warning",
      important = "warning",
      shorthandProperties = "warning",
      vendorPrefix = "warning",
      zeroUnits = "warning",
    },
    completion = {
      completePropertyWithSemicolon = true,
      triggerPropertyValueCompletion = true,
    },
    hover = true,
    colorProvider = true,
    format = { enable = true },
  },
  less = {
    validate = true,
    lint = {
      unknownAtRules = "warning",
      boxModel = "warning",
      duplicateProperties = "warning",
      emptyRules = "warning",
      important = "warning",
      shorthandProperties = "warning",
      vendorPrefix = "warning",
      zeroUnits = "warning",
    },
    completion = {
      completePropertyWithSemicolon = true,
      triggerPropertyValueCompletion = true,
    },
    hover = true,
    colorProvider = true,
    format = { enable = true },
  },
})

-- Enable inlay hints + semantic tokens if available (Neovim 0.11+ safe)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if not client or not client.server_capabilities then
      return
    end

    --  Inlay hints (new API)
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    --  Semantic tokens
    if
      client.server_capabilities.semanticTokensProvider
      and vim.lsp.semantic_tokens
    then
      vim.lsp.semantic_tokens.start(bufnr, client.id)

      -- light refresh on insert leave
      local group =
        vim.api.nvim_create_augroup("LspSemanticRefresh", { clear = false })
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = group,
        buffer = bufnr,
        callback = function()
          pcall(vim.lsp.semantic_tokens.force_refresh)
        end,
      })
    end
  end,
})

-- Expected LSP servers (system-installed)
local expected_lsps = {
  lua_ls = "lua-language-server",
  clangd = "clangd",
  ccls = "ccls",
  yamlls = "yaml-language-server",
  ts_ls = "typescript-language-server",
}

-- Native LSP info command with system check
vim.api.nvim_create_user_command("NativeLspInfo", function()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Check for missing binaries
  local missing = {}
  for lsp, bin in pairs(expected_lsps) do
    if vim.fn.executable(bin) == 0 then
      table.insert(missing, lsp .. " (" .. bin .. ")")
    end
  end
  if #missing > 0 then
    print("Warning: Missing LSP binaries: " .. table.concat(missing, ", "))
  end

  -- Get active clients
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if vim.tbl_isempty(clients) then
    print("No active LSP clients attached to this buffer")
    return
  end

  print("Active LSP Clients for buffer " .. bufnr .. ":")
  for _, client in ipairs(clients) do
    print("  - " .. client.name)
    if client.config and client.config.root_dir then
      print("      Root: " .. client.config.root_dir)
    end

    local caps = client.server_capabilities or {}
    local cap_list = {}
    if caps.hoverProvider then
      table.insert(cap_list, "hover")
    end
    if caps.renameProvider then
      table.insert(cap_list, "rename")
    end
    if caps.definitionProvider then
      table.insert(cap_list, "definition")
    end
    if caps.referencesProvider then
      table.insert(cap_list, "references")
    end
    if caps.documentFormattingProvider then
      table.insert(cap_list, "formatting")
    end
    if caps.documentRangeFormattingProvider then
      table.insert(cap_list, "range_formatting")
    end
    if caps.completionProvider then
      table.insert(cap_list, "completion")
    end

    print("      Capabilities: " .. table.concat(cap_list, ", "))
  end
end, { desc = "Show info for native LSP clients (checks system binaries)" })

-- Quick LSP restart command
vim.api.nvim_create_user_command("LspRestart", function()
  for _, client in pairs(vim.lsp.get_clients()) do
    client:stop()
  end
  vim.cmd("edit") -- re-triggers FileType autocmd to restart
  print("LSP clients restarted")
end, { desc = "Restart all active LSP clients" })
