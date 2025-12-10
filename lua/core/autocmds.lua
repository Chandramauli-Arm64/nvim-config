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
