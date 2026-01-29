---@brief
---
---https://github.com/vlang/v-analyzer
---
--- V language server (Termux implementation).
---
--- `v-analyzer` can be installed by following the instructions [here](https://github.com/vlang/v-analyzer#installation).

---@type vim.lsp.Config
return {
  cmd = { "v-analyzer", "--stdio" },
  filetypes = { "v", "vsh", "vv" },
  root_markers = { "v.mod", ".git" },
}
