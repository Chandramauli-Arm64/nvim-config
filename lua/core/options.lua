-- Create the `core` module
local opt = vim.opt
local g = vim.g

-- Leader Key
g.mapleader = " "
g.maplocalleader = " "
-- General
opt.termguicolors = true
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard (if available)
opt.completeopt = { "menuone", "noselect" }

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.smartindent = true -- Auto indent new lines

-- UI
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Highlight current line
opt.wrap = false -- Disable line wrap
opt.scrolloff = 8 -- Keep at least 8 lines above/below the cursor
opt.sidescrolloff = 8 -- Keep at least 8 columns left/right of the cursor

-- Searching
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Override ignorecase if upper case used
opt.incsearch = true -- Show matches as you type
opt.hlsearch = false -- Don't highlight matches after search

-- Performance
opt.updatetime = 300
opt.timeoutlen = 500

-- File management
opt.swapfile = false
opt.backup = false
opt.undofile = true -- Persistent undo
opt.autowrite = true -- Auto save before actions like :next or :make

-- Termux / Mobile Friendly
g.loaded_python_provider = 0 -- Disable Python2 provider
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Color column (optional)
opt.colorcolumn = "80"

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- fileencoding
vim.o.fileencoding = "utf-8"

-- Cursor
opt.cursorline = true
opt.cursorcolumn = false
