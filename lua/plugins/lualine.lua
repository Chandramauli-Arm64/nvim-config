return {
  'nvim-lualine/lualine.nvim',
  config = function()
    -- Colors for theme
    local colors = {
      blue = '#61afef', green = '#98c379', purple = '#c678dd',
      cyan = '#56b6c2', red1 = '#e06c75', red2 = '#be5046',
      yellow = '#e5c07b', fg = '#abb2bf', bg = '#282c34',
      gray1 = '#828997', gray2 = '#2c323c', gray3 = '#3e4452',
    }

    local onedark_theme = {
      normal = { a = { fg = colors.bg, bg = colors.green, gui = 'bold' } },
      insert = { a = { fg = colors.bg, bg = colors.blue, gui = 'bold' } },
      visual = { a = { fg = colors.bg, bg = colors.purple, gui = 'bold' } },
      replace = { a = { fg = colors.bg, bg = colors.red1, gui = 'bold' } },
      inactive = { a = { fg = colors.gray1, bg = colors.bg, gui = 'bold' } },
    }

    local themes = { onedark = onedark_theme, nord = 'nord' }
    local env_theme = os.getenv('NVIM_THEME') or 'nord'

    local hide_in_width_mobile = function()
      return vim.fn.winwidth(0) > 70 -- Adjusted for mobile screens
    end

    local mode = {
      'mode',
      fmt = function(str)
        return ' ' .. str:sub(1, 1) -- Display only first letter of mode
      end,
    }

    local filename = { 'filename', file_status = true, path = 1 } -- Relative path for better navigation

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ' }, -- Removed info & hint for simplicity
      colored = false,
      always_visible = false,
      cond = hide_in_width_mobile,
    }

    local diff = {
      'diff',
      symbols = { added = ' ', modified = '柳', removed = ' ' }, -- Minimalistic symbols
      cond = hide_in_width_mobile,
    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = themes[env_theme],
        section_separators = { left = '', right = '' }, -- No extra separators for mobile
        component_separators = { left = '│', right = '│' }, -- Thin separators
        disabled_filetypes = { 'alpha', 'neo-tree', 'Avante' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { 'branch' },
        lualine_c = { filename },
        lualine_x = { diagnostics, diff, { 'filetype', cond = hide_in_width_mobile } },
        lualine_y = { 'location' },
        lualine_z = { 'progress' },
      },
      inactive_sections = {
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { { 'location', padding = 0 } },
      },
      extensions = { 'fugitive' },
    }
  end,
}
