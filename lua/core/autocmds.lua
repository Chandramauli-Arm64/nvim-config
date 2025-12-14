vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Lazygit
vim.api.nvim_create_user_command("Lazygit", function()
  vim.fn.termopen("lazygit")
  vim.cmd("startinsert")
end, { desc = "Lazygit in floating terminal" })

-- lldb (debugger)
vim.api.nvim_create_user_command("Lldb", function()
  vim.fn.termopen("lldb")
  vim.cmd("startinsert")
end, { desc = "LLDB in floating terminal" })

-- Lsp Restart command
vim.api.nvim_create_user_command("LspRestart", function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop()
  end
  vim.cmd("edit")
  print("LSP restarted.")
end, {})

-- Auto-close buffers that are NOT modified when leaving them,
-- but do NOT close when switching to help/checkhealth/tutor/docs/diagnostic-like buffers.
local transient_filetypes = {
  "help",
  "checkhealth",
  "man",
  "qf", -- quickfix / diagnostics lists
  "lspinfo",
  "fugitive",
  "git",
  "Trouble",
  "toggleterm",
  "NvimTree",
  "startify",
  "dashboard",
  "packer",
  "lazy",
  "nvim-tree",
}

local function is_transient_buf(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local bt = vim.bo[bufnr].buftype or ""
  if bt ~= "" then
    return true
  end

  local ft = vim.bo[bufnr].filetype or ""
  for _, t in ipairs(transient_filetypes) do
    if ft == t then
      return true
    end
  end

  -- Consider unlisted or non-modifiable buffers as transient as well
  if vim.fn.buflisted(bufnr) == 0 then
    return true
  end
  if vim.bo[bufnr].modifiable == false then
    return true
  end

  return false
end

vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    local buf = args.buf
    -- If buffer itself is special (terminal/help etc) — ignore
    if vim.bo[buf].buftype ~= "" then
      return
    end

    -- If buffer is modified, keep it
    if vim.bo[buf].modified then
      return
    end

    -- If buffer is not listed, ignore
    if vim.fn.buflisted(buf) == 0 then
      return
    end

    -- Don't delete if it's the last listed buffer
    local listed = vim.tbl_filter(function(b)
      return vim.fn.buflisted(b) == 1
    end, vim.api.nvim_list_bufs())

    if #listed <= 1 then
      return
    end

    -- Defer actual deletion check one tick and re-validate destination buffer.
    vim.schedule(function()
      -- buffer might have become invalid in the meantime
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      -- If buffer became modified meanwhile, keep it
      if vim.bo[buf].modified then
        return
      end

      -- Destination buffer: current buffer after leaving `buf`
      local dest = vim.api.nvim_get_current_buf()

      -- If destination is transient (help, docs, diagnostics...), do NOT delete previous buffer.
      if is_transient_buf(dest) then
        return
      end

      -- Recompute listed buffers (safety)
      local listed_now = vim.tbl_filter(function(b)
        return vim.fn.buflisted(b) == 1
      end, vim.api.nvim_list_bufs())

      if #listed_now <= 1 then
        return
      end

      -- Finally delete safely (no force)
      if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.cmd, "bdelete " .. buf)
      end
    end)
  end,
})
