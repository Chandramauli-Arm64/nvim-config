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

-- local autocomplete
local triggers = { "." }
vim.api.nvim_create_autocmd("InsertCharPre", {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function()
    if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
      return
    end
    local char = vim.v.char
    if vim.list_contains(triggers, char) then
      local key = vim.keycode("<C-x><C-n>")
      vim.api.nvim_feedkeys(key, "m", false)
    end
  end,
})

-- number toggel
-- Add this to your init.lua
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function()
    local size = vim.fn.getfsize(vim.fn.expand("<afile>"))
    if size > 1024 * 1024 then -- Files > 1MB
      -- 1. Switch from Relative to Absolute (Stops redraw lag)
      vim.wo.relativenumber = false
      vim.wo.number = true
      -- 2. Cap the syntax scanning (Stops horizontal lag)
      vim.opt_local.synmaxcol = 150
      -- 3. Disable heavy features for this buffer only
      vim.cmd("syntax sync minlines=10") -- Don't look too far back for context
    end
  end,
})
