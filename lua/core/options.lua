-- General Settings
vim.opt.number = true            -- Show line numbers
vim.opt.relativenumber = true    -- Relative line numbers
vim.opt.mouse = "a"              -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard (if Termux supports it)
vim.opt.termguicolors = true     -- Enable true colors
vim.opt.cursorline = true        -- Highlight the current line
vim.opt.scrolloff = 8            -- Keep at least 8 lines above/below the cursor
vim.opt.sidescrolloff = 8        -- Keep at least 8 columns left/right of the cursor
vim.opt.wrap = false             -- Disable line wrapping

-- Indentation Settings
vim.opt.tabstop = 4              -- Number of spaces per tab
vim.opt.shiftwidth = 4           -- Indentation width
vim.opt.expandtab = true         -- Convert tabs to spaces
vim.opt.smartindent = true       -- Auto-indent new lines

-- Searching
vim.opt.ignorecase = true        -- Ignore case in search
vim.opt.smartcase = true         -- Override ignorecase if search contains uppercase
vim.opt.incsearch = true         -- Show search matches as you type
vim.opt.hlsearch = false         -- Don't highlight search matches after done

-- Backup & Undo
vim.opt.swapfile = false         -- Disable swap files
vim.opt.backup = false           -- Disable backup files
vim.opt.undofile = true          -- Enable persistent undo

-- Performance
vim.opt.updatetime = 250         -- Reduce update time for better UX
vim.opt.timeoutlen = 500         -- Faster key sequence timeout

-- Split Windows Behavior
vim.opt.splitright = true        -- Open vertical splits to the right
vim.opt.splitbelow = true        -- Open horizontal splits below

-- Set Python 3 host program explicitly for Neovim Python provider
vim.g.python3_host_prog = '/data/data/com.termux/files/usr/bin/python3'

-- Perl provider off
vim.g.loaded_perl_provider = 0
