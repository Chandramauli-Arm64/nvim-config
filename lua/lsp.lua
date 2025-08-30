-- Nerd Font icons for diagnostics
local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Attach function (runs when LSP attaches to buffer)
local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  bufmap("n", "gr", vim.lsp.buf.references, "Find References")
  bufmap("n", "K", vim.lsp.buf.hover, "Hover Docs")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  bufmap("n", "ca", vim.lsp.buf.code_action, "Code Action")
  bufmap("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  bufmap("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
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
            vim.fs.find({ ".git", ".root" }, { upward = true })[1]
          ),
          on_attach = on_attach,
          capabilities = capabilities,
          settings = settings,
        })
      end,
    })
  end
end

-- Configure servers (system binaries only)
start_server({ "lua-language-server" }, { "lua" }, {
  Lua = {
    diagnostics = { globals = { "vim" } },
    workspace = { checkThirdParty = false },
  },
})

start_server({ "clangd" }, { "c", "cpp" })
start_server({ "ccls" }, { "c", "cpp" })
start_server({ "yaml-language-server", "--stdio" }, { "yaml" })

-- Expected LSP servers (system-installed)
local expected_lsps = {
  lua_ls = "lua-language-server",
  clangd = "clangd",
  ccls = "ccls",
  yamlls = "yaml-language-server",
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
    if client.config.root_dir then
      print("      Root: " .. client.config.root_dir)
    end

    local caps = client.server_capabilities
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
