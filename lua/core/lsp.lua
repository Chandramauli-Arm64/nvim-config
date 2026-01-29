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
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end
M.capabilities = capabilities

-- Helper: Build root_dir function if only root_markers exists
local function build_root_dir_from_markers(markers)
  return function(fname)
    if not markers or not vim.islist(markers) then
      return vim.fn.fnamemodify(fname, ":p:h")
    end
    return vim.fs.root(fname, markers) or vim.fn.fnamemodify(fname, ":p:h")
  end
end

-- Infer the root directory logic for each server config:
local function inject_root_dir(server)
  if server.root_dir then
    return server
  end
  if server.root_markers then
    server.root_dir = build_root_dir_from_markers(server.root_markers)
  end
  return server
end

-- Register server: minimal, clean, fast

local function register_server_table(name, server)
  if not server or not server.filetypes then
    return
  end

  inject_root_dir(server)

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    callback = function(args)
      local bufnr = args.buf
      local ft = vim.bo[bufnr].filetype

      if not vim.tbl_contains(server.filetypes, ft) then
        return
      end

      local fname = vim.api.nvim_buf_get_name(bufnr)
      local root_dir = nil

      if type(server.root_dir) == "function" then
        local ok, ret = pcall(server.root_dir, fname)
        root_dir = (ok and ret) or nil
      end

      root_dir = root_dir or vim.loop.cwd()

      local on_attach = server.on_attach
          and function(client, b)
            M.on_attach(client, b)
            server.on_attach(client, b)
          end
        or M.on_attach

      -- Merge completion capabilities (unchanged logic)
      local final_capabilities = server.capabilities
          and vim.tbl_deep_extend(
            "force",
            vim.deepcopy(M.capabilities),
            server.capabilities
          )
        or vim.deepcopy(M.capabilities)

      local opts = {
        name = name,
        cmd = server.cmd,
        filetypes = server.filetypes,
        root_dir = root_dir,
        on_attach = on_attach,
        capabilities = final_capabilities,
        settings = server.settings,
        handlers = server.handlers,
        flags = server.flags
          or { debounce_text_changes = 50, exit_timeout = 500 },
        init_options = server.init_options,
        on_init = server.on_init,
        commands = server.commands,
      }

      if
        type(opts.cmd) == "table"
        and opts.cmd[1]
        and vim.fn.executable(opts.cmd[1]) == 0
      then
        vim.notify(
          ("[LSP] Skipping '%s': Binary '%s' not executable."):format(
            name,
            opts.cmd[1]
          ),
          vim.log.levels.WARN
        )
        return
      end

      vim.lsp.start(opts)
    end,
  })
end

M.register_server_table = register_server_table

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

-- Commands
local expected_lsps = {
  lua_ls = "lua-language-server",
  clangd = "clangd",
  python = "basedpyright", -- update to "basedpyright-langserver" if you use basedpyright only
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
      print("Root: " .. tostring(client.config.root_dir))
    end
  end
end, {})

-- Auto-run all server files
M.setup_servers()
return M
