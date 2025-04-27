return {
  'nvim-neo-tree/neo-tree.nvim',
  event = 'VeryLazy',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

    require('neo-tree').setup {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sort_case_insensitive = false,
      window = {
        position = 'left',
        width = 25, -- Reduce width for mobile
      },
      default_component_configs = {
        indent = {
          indent_size = 2,
          with_markers = true,
          expander_collapsed = '',
          expander_expanded = '',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
        },
        file_size = { enabled = true, required_width = 40 },
        type = { enabled = false },
        last_modified = { enabled = false },
        created = { enabled = false },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = { '.git', 'node_modules', '__pycache__' },
        },
      },
    }
      end,
 } 

