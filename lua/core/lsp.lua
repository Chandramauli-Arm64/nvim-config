-- lua/core/lsp.lua
local M = {}

-- Diagnostics

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

-- Global on_attach

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

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

  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { buffer = bufnr })
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { buffer = bufnr })
  bufmap("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")

  bufmap("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols")
  bufmap("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
end

-- Capabilities (completion support)

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp and cmp_lsp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end
M.capabilities = capabilities

-- Registry to prevent double-start

M._registry = {}

-- Register server: minimal, clean, fast

local function register_server_table(name, server)
  if not server or not server.filetypes then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = server.filetypes,
    callback = function(args)
      local bufnr = args.buf
      local fname = vim.api.nvim_buf_get_name(bufnr)

      -- lspconfig style: root_dir is handled by the server file itself
      local root_dir = nil
      if type(server.root_dir) == "function" then
        pcall(function()
          root_dir = server.root_dir(fname)
        end)
      end

      -- fallback to cwd if needed
      root_dir = root_dir or vim.loop.cwd()

      local key = name .. "::" .. root_dir
      if M._registry[key] then
        return
      end

      local on_attach = server.on_attach
          and function(client, b)
            M.on_attach(client, b)
            server.on_attach(client, b)
          end
        or M.on_attach

      local opts = {
        name = name,
        cmd = server.cmd,
        filetypes = server.filetypes,
        root_dir = root_dir,
        on_attach = on_attach,
        capabilities = vim.tbl_deep_extend(
          "force",
          M.capabilities,
          server.capabilities or {}
        ),
        settings = server.settings,
        handlers = server.handlers,
        flags = server.flags
          or { debounce_text_changes = 50, exit_timeout = 500 },
      }

      -- ensure binary exists
      if
        type(opts.cmd) == "table"
        and opts.cmd[1]
        and vim.fn.executable(opts.cmd[1]) == 0
      then
        return
      end

      local ok, client_id = pcall(vim.lsp.start, opts)
      if ok and client_id then
        M._registry[key] = client_id
      end
    end,
  })
end

M.register_server_table = register_server_table

-- Old compatibility wrapper

function M.start_server(cmd, filetypes, settings)
  if type(cmd) == "table" and (cmd.cmd or cmd.filetypes) and not filetypes then
    return register_server_table(cmd.name or cmd.cmd[1], cmd)
  end

  register_server_table(cmd[1], {
    cmd = cmd,
    filetypes = filetypes,
    settings = settings,
  })
end

-- Auto-load server files: lua/lsp/servers/*.lua

function M.setup_servers()
  local dir = vim.fn.stdpath("config") .. "/lua/lsp/servers"
  local ok = pcall(vim.loop.fs_stat, dir)
  if not ok then
    return
  end

  local files = vim.fn.globpath(dir, "*.lua", false, true)
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ":t:r")
    local ok2, server = pcall(require, "lsp.servers." .. name)
    if ok2 and server then
      register_server_table(server.name or name, server)
    end
  end
end

-- LspAttach: inlay hints + semantic tokens

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if not client then
      return
    end

    if client.server_capabilities.inlayHintProvider then
      pcall(vim.lsp.inlay_hint, bufnr, true)
    end

    if client.server_capabilities.semanticTokensProvider then
      pcall(vim.lsp.semantic_tokens.start, bufnr, client.id)
      vim.api.nvim_create_autocmd("InsertLeave", {
        buffer = bufnr,
        callback = function()
          pcall(vim.lsp.semantic_tokens.force_refresh)
        end,
      })
    end
  end,
})

-- Commands

local expected_lsps = {
  lua_ls = "lua-language-server",
  clangd = "clangd",
  python = "pyright",
  yamlls = "yaml-language-server",
  ts_ls = "typescript-language-server",
  cssls = "vscode-css-language-server",
  perlls = "pls",
}

vim.api.nvim_create_user_command("NativeLspInfo", function()
  local bufnr = vim.api.nvim_get_current_buf()

  local missing = {}
  for lsp, bin in pairs(expected_lsps) do
    if vim.fn.executable(bin) == 0 then
      table.insert(missing, lsp .. " (" .. bin .. ")")
    end
  end
  if #missing > 0 then
    print("Warning: Missing LSP binaries: " .. table.concat(missing, ", "))
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if vim.tbl_isempty(clients) then
    print("No active LSP clients attached")
    return
  end

  print("Active LSP Clients:")
  for _, client in ipairs(clients) do
    print("  - " .. client.name)
    if client.config.root_dir then
      print("Root: " .. client.config.root_dir)
    end
  end
end, {})

-- Auto-run all server files
M.setup_servers()
return M
