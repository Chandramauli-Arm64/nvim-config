local M = {}

---------------------------------------------------------
-- Diagnostics
---------------------------------------------------------
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

---------------------------------------------------------
-- Hover & Signature UI Borders
---------------------------------------------------------
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.buf.hover({ border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.buf.signature_help({ border = "rounded" })

---------------------------------------------------------
-- Capabilities
---------------------------------------------------------
-- local caps = vim.lsp.protocol.make_client_capabilities()
-- local ok, cmp = pcall(require, "cmp_nvim_lsp")
-- if ok then
--   caps = cmp.default_capabilities(caps)
-- end
-- M.capabilities = caps

---------------------------------------------------------
-- Global LspAttach Handler
---------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("CoreLspAttach", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if not client then
      return
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -----------------------------------------------------
    -- Keymaps
    -----------------------------------------------------

    if client:supports_method("textDocument/definition") then
      map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
    end

    if client:supports_method("textDocument/references") then
      map("n", "gr", vim.lsp.buf.references, "Find References")
    end

    if client:supports_method("textDocument/hover") then
      map("n", "K", vim.lsp.buf.hover, "Hover Docs")
    end

    if client:supports_method("textDocument/rename") then
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    end

    if client:supports_method("textDocument/codeAction") then
      map("n", "ca", vim.lsp.buf.code_action, "Code Action")
    end

    if client:supports_method("textDocument/signatureHelp") then
      map("n", "<leader>sh", vim.lsp.buf.signature_help, "Signature Help")
    end

    -----------------------------------------------------
    -- Diagnostics Navigation
    -----------------------------------------------------
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Prev Diagnostic")

    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next Diagnostic")

    map("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")

    -----------------------------------------------------
    -- Symbols
    -----------------------------------------------------
    if client:supports_method("textDocument/documentSymbol") then
      map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols")
    end

    if client:supports_method("workspace/symbol") then
      map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
    end

    -----------------------------------------------------
    -- Completion
    -----------------------------------------------------
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
    map("i", "<c-space>", function()
      vim.lsp.completion.get()
    end)
  end,
})

---------------------------------------------------------
-- Load Server Configs
---------------------------------------------------------
function M.setup_servers()
  local dir = vim.fn.stdpath("config") .. "/lua/lsp/servers"
  for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    local ok2, server = pcall(require, "lsp.servers." .. name)
    if ok2 and server then
      vim.lsp.config[name] = vim.tbl_deep_extend("force", {
        capabilities = M.capabilities,
      }, server)

      vim.lsp.enable(name)
    end
  end
end

M.setup_servers()
return M
