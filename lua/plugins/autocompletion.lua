return {
  "hrsh7th/nvim-cmp",

  -- Load when entering insert mode or reading a buffer
  event = { "LspAttach" },

  dependencies = {
    -- Core completion sources
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp-signature-help",

    -- Snippet engine
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
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },

    -- cmp snippet source
    "saadparwaiz1/cmp_luasnip",
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local wk = require("which-key")

    -- setup snippet
    luasnip.config.setup({
      history = true,
      updateevents = "TextChanged",
      "TextChangedI",
    })

    -- icons
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
      enabled = function()
        local buftype = vim.bo.buftype
        if buftype == "prompt" then
          return false
        end

        local ft = vim.bo.filetype
        local blacklist = {
          markdown = true,
          gitcommit = true,
          text = true,
          help = true,
        }

        return not blacklist[ft]
      end,

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      completion = {
        completeopt = "menu,menuone,noinsert",
        autocomplete = { cmp.TriggerEvent.TextChanged },
        keyword_length = 1,
        max_item_count = 8,
      },

      performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 120,
      },

      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
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

        ["<CR>"] = cmp.mapping.confirm({ select = false }),
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

    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    -- toggle cmp
    vim.keymap.set("n", "<leader>ut", function()
      local enabled = cmp.get_config().enabled ~= false
      cmp.setup({ enabled = not enabled })
      print("Cmp " .. (enabled and "OFF" or "ON"))
    end, { desc = "Toggle cmp" })

    -- which-key registration
    wk.add({
      { "<Tab>", "Next completion / expand snippet", mode = { "i", "s" } },
      { "<S-Tab>", "Prev completion / jump snippet", mode = { "i", "s" } },
      { "<C-Space>", "Trigger completion", mode = "i" },
      { "<C-b>", "Scroll docs up", mode = "i" },
      { "<C-f>", "Scroll docs down", mode = "i" },
      { "<leader>u", group = "utility" },
      { "<leader>ut", desc = "Toggle cmp", mode = "n" },
    })
  end,
}
