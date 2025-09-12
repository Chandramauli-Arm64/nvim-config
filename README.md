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
  <img src="https://img.shields.io/github/traffic-sources-clones/Chandramauli-Arm64/nvim-config?style=for-the-badge&logo=github&logoColor=white&color=1abc9c" alt="Clones" />
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

- No nonsense plugins which you will never use.
- Simple, efficient, reliable setup.
- Theme: [OneDark Dark](https://github.com/olimorris/onedarkpro.nvim)
- Lazy.nvim for plugin management.
- Tree-sitter for syntax highlighting.
- Telescope & FzF for fuzzy finding.
- NativeLsp + Autocompletion (nvim-cmp, blinkcpm etc.).
- Conform.nvim support for native formatting and linting.
- Which-key.nvim if you forget the keymappings.
- Render-markdown.nvim for better writing experience.
- Folke/trouble.nvim for issue hunting.
- **PLUGINS**: 25 ( 11 lazy loaded)

---

## Metrics (from my logs)

- **Startup Time**: 178.7ms-234.86ms

  - LazyStart: 25.17ms

  - LazyDone: 219.19ms (+194.03ms)

  - UIEnter: 234.86ms (+15.66ms)


- **Plugin Load Times (Top Heavy)**

  - nvim-tree.lua: 108.57ms

  - telescope.nvim: 87.81ms

  - nvim-treesitter: 51.73ms

  - onedarkpro.nvim: 32.42ms

  - lualine.nvim (+ lsp-progress): 42.64ms


- **Light Plugins (under 5ms)**

  - cmp-nvim-lsp: 5.24ms

  - which-key.nvim: 6.62ms (init)

  - Most cmp + linting extensions: 0.5–3ms

---

**If you want to test it in your smartphone you can clone the repo**:

```
git clone https://github.com/Chandramauli-Arm64/nvim-config ~/.config/nvim
```

- **Windows**:

```powershell
git clone https://github.com/Chandramauli-Arm64/nvim-config.git $env:LOCALAPPDATA\nvim
```

---

## THEME NOTES

- Default theme: onedark_dark.
- You can switch theme as per your liking.
- For Termux users, don't use **italics** font. It will break while zooming or zoomeout.

---

## PERSONAL NOTES

- Works on Termux(**Android**) and other platforms e.g Linux.
- Transparency disabled for stability in Termux.
- The codes you will find in this config is not written by me and taken from official docs of plugins.
- There are some **AI** written codes too but they have been written via taking the direct reference from the official documentation.
- This config is not perfect and I will try to make it better not perfect because perfectism is an illusion.

> [!IMPORTANT]
> Tree-sitter **rainbow** is disabled to improve performance in **Termux**. If you have better device than mine then enable it or re-write the code as per your liking.

<details>
  <summary><b>Treesitter Configuration (click to expand)</b></summary>

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
</details>

---

## CONTRIBUTION

Check [Contribution](CONTRIBUTING.md) for more information.

---

## LICENSE

This configuration is licensed under the [MIT License](LICENSE.md)

---

### THANKS FOR READING!
