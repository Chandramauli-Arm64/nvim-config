require("core.options")

vim.g.mapleader = " "

require("core.keymap")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
require("plugins.icons"),
require("plugins.theme"),
require("plugins.lualine"),
require("plugins.buffer"),
require("plugins.indentation"),
require("plugins.which-key"),
require("plugins.noice"),
require("plugins.telescope"),
require("plugins.neo-tree"),
require("plugins.treesitter"),
require("plugins.lsp"),
require("plugins.completion"),
require("plugins.none-ls"),
require("plugins.debug"),
require("plugins.nerdy"),
require("plugins.mark-preview"),
require("plugins.nerdy"),
require("plugins.lazygit")
})
