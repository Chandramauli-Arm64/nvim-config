-- lua/native_telescope/init.lua

local ui = require("scope.ui")
local finder = require("scope.finder")
---@diagnostic disable-next-line: unused-local
local fuzzy = require("scope.fuzzy")

local M = {}

function M.find_files()
  local files = finder.find_files()

  local buf, win = ui.create_window()

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, files)

  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()

    vim.api.nvim_win_close(win, true)

    vim.cmd("edit " .. line)
  end, { buffer = buf })
end

-- Keymaps
vim.keymap.set("n", "<leader>ff", function()
  require("scope").find_files()
end)

return M
