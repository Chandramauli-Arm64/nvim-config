![Alt](https://repobeats.axiom.co/api/embed/9ff72f6cf7ac1734000ae26bfd8e23118b51aedb.svg "Repobeats analytics image")

[![Contributors](https://contrib.rocks/image?repo=Chandramauli-Arm64/nvim-config)](https://github.com/Chandramauli-Arm64/nvim-config/graphs/contributors)

<p align="center">
  <img src="https://img.shields.io/github/languages/top/Chandramauli-Arm64/nvim-config?color=1abc9c&style=for-the-badge&logo=lua" alt="Top Language" />
  <img src="https://vbr.nathanchung.dev/badge?page_id=Chandramauli-Arm64.nvim-config&logo=github&color=1abc9c&style=for-the-badge" alt="Visitors" />
  <img src="https://img.shields.io/github/repo-size/Chandramauli-Arm64/nvim-config?color=1abc9c&style=for-the-badge&logo=github" alt="Repo Size" />
  <img src="https://img.shields.io/github/last-commit/Chandramauli-Arm64/nvim-config?color=1abc9c&style=for-the-badge&logo=git" alt="Last Commit" />
  <img src="https://img.shields.io/github/stars/Chandramauli-Arm64/nvim-config?color=1abc9c&style=for-the-badge&logo=github" alt="Stars" />
  <img src="https://img.shields.io/github/forks/Chandramauli-Arm64/nvim-config?color=1abc9c&style=for-the-badge&logo=github" alt="Forks" />
  <img src="https://img.shields.io/github/license/Chandramauli-Arm64/nvim-config?color=1abc9c&style=for-the-badge&logo=open-source-initiative" alt="License" />
  <img src="https://img.shields.io/badge/Neovim-config-1abc9c?style=for-the-badge&logo=neovim&logoColor=white" alt="Neovim" />
</p>

![Quote](https://quotes-github-readme.vercel.app/api?type=horizontal&theme=radical)

# nvim-config

My simple neovim configuration for termux(android) based on **Lazy.vim** with a dark theme, some plugins, and workflow tweaks for ANDROID.

**Device Info**:
- REALME P1 5G
- ANDROID VERSION: 15
- RAM: 6 GB
- ROM: 128 GB
- CPU: Mediatek Dimensity 7050

---

## PLUGINS AND FEATURES

- Theme: [OneDark Dark](https://github.com/olimorris/onedarkpro.nvim)
- Lazy.nvim for plugin management.
- Tree-sitter for syntax highlighting.
- Telescope & FzF for fuzzy finding.
- NativeLsp + Autocompletion (nvim-cmp, blinkcpm etc.).
- Conform.nvim support for native formatting and linting.

---

**If you want to test it in your smartphone you can clone the repo**:

```
git clone https://github.com/Chandramauli-Arm64/nvim-config ~/.config/nvim
```

---

## THEME NOTES

- Default theme: onedark_dark.
- You can switch theme as per your liking.
- Don't use **italics** font. It will break while zooming or zoomeout.

---

## PERSONAL NOTES

- Works on Termux(**Android**) and other platforms e.g Linux.
- Transparency disabled for stability in Termux.

> [!IMPORTANT]
> Tree-sitter **rainbow** is disabled to improve performance in **Termux**. If you have better device than mine then enable it or re-write the code as per your liking.

**Here**:-

```lua
-- treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "master",
  lazy = false,
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Languages to install
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "vim",
        "vimdoc",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, buf)
          local max_filesize = 50 * 1024 -- 150 KB limit for mobile speed
          local ok, stats =
            pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
          return false
        end,
      },

      indent = { enable = false },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
        },
      },

      matchup = { enable = true },
      autopairs = { enable = true },
      rainbow = { enable = false }, -- Disabled to prevent mobile lag
    })
  end,
}
```

---

## LICENSE

This configuration is licensed under the [MIT License](LICENSE.md)
