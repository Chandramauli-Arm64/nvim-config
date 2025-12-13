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

-- Copy to clipboard
vim.api.nvim_create_user_command("CopyToPhone", function()
  vim.cmd('normal! "+y')
  local text = vim.fn.getreg("+")
  if text and text ~= "" then
    vim.fn.system({ "termux-clipboard-set" }, text)
  end
end, { range = true })

-- Auto-close buffers that are NOT modified when leaving them
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    local buf = args.buf

    -- Ignore special buffers
    if vim.bo[buf].buftype ~= "" then
      return
    end

    -- If buffer is modified, keep it
    if vim.bo[buf].modified then
      return
    end

    -- If buffer is not listed, ignore
    if not vim.bo[buf].buflisted then
      return
    end

    -- Don't delete if it's the last listed buffer
    local listed = vim.tbl_filter(function(b)
      return vim.fn.buflisted(b) == 1
    end, vim.api.nvim_list_bufs())

    if #listed <= 1 then
      return
    end

    -- Delete buffer safely (no force)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.cmd, "bdelete " .. buf)
      end
    end)
  end,
})
