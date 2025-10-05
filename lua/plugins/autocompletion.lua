return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter" },
  ft = { "lua", "python", "javascript", "typescript", "vue", "css", "html" },
  dependencies = {
    -- Core completion sources
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp-signature-help",

    -- Snippet engine & extras
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = {} })
        end,
      },
    },
    "saadparwaiz1/cmp_luasnip",
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local wk = require("which-key")

    luasnip.config.setup({})

    -- Nerd Font icons
    local kind_icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰀫",
      Class = "󰌗",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰇽",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰊄",
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      completion = {
        completeopt = "menu,menuone,noinsert",
        autocomplete = { cmp.TriggerEvent.TextChanged },
        keyword_length = 1,
        max_item_count = 8, -- compact list for mobile
      },

      performance = {
        debounce = 60, -- ms to wait after input before triggering completion
        throttle = 30, -- ms to wait before updating completion menu
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 120,
      },

      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
          scrollbar = false,
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:CmpDocBorder,CursorLine:PmenuSel,Search:None",
        }),
      },

      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() then
            cmp.confirm({ select = false })
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lsp_signature_help" },
      }, {
        { name = "buffer", keyword_length = 3, max_item_count = 5 },
        { name = "path", keyword_length = 2 },
      }),

      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = (kind_icons[vim_item.kind] or "") .. " "
          vim_item.menu = ({
            nvim_lsp = "󰒋 LSP",
            luasnip = "󰘌 Snip",
            buffer = "󰈙 Buf",
            path = "󰉋 Path",
            nvim_lsp_signature_help = "󰆩 Sig",
          })[entry.source.name]
          return vim_item
        end,
      },

      experimental = {
        ghost_text = { hl_group = "CmpGhostText" },
      },
    })

    -- subtle ghost text style
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    -- Toggle cmp easily (for mobile typing)
    vim.keymap.set("n", "<leader>ut", function()
      local cmp_enabled = cmp.get_config().enabled ~= false
      cmp.setup({ enabled = not cmp_enabled })
      print("Cmp " .. (cmp_enabled and "OFF" or "ON"))
    end, { desc = "Toggle cmp" })

    -- Register with which-key
    wk.add({
      -- Insert/Select mode keymaps
      { "<Tab>", "Next completion item / expand snippet", mode = { "i", "s" } },
      {
        "<S-Tab>",
        "Previous completion item / jump snippet",
        mode = { "i", "s" },
      },
      { "<C-Space>", "Trigger completion menu", mode = "i" },
      { "<C-b>", "Scroll docs up", mode = "i" },
      { "<C-f>", "Scroll docs down", mode = "i" },

      -- Normal mode utility
      { "<leader>u", group = "utility" },
      { "<leader>ut", desc = "Toggle cmp (completion engine)", mode = "n" },
    })
  end,
}
