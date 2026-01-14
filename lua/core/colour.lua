local set = vim.api.nvim_set_hl

--------------------------------------------------
-- Accent palette (complements Neovim defaults)
--------------------------------------------------
local accent = {
  type = "#e0af68", -- amber (types) → contrasts green
  constant = "#9ece6a", -- green (aligns with native green)
  func = "#5f87d7", -- indigo (separate from default blue 🔵)
  macro = "#b38df7", -- violet (no collision)
  keyword = "#6fa4b8", -- muted teal (between cyan & blue)
}

--------------------------------------------------
-- Core readability (ONE strong anchor)
--------------------------------------------------
set(0, "CursorLineNr", { bold = true })

--------------------------------------------------
-- Comments (ONLY italics in entire theme)
--------------------------------------------------
set(0, "Comment", { italic = true, fg = "#5c6370" })
set(0, "@comment", { link = "Comment" })
set(0, "@lsp.type.comment", { link = "Comment" })

--------------------------------------------------
-- Classic syntax (fallback)
--------------------------------------------------
set(0, "Function", { fg = accent.func })
set(0, "Keyword", { fg = accent.keyword })

set(0, "Type", { fg = accent.type })
set(0, "Constant", { fg = accent.constant })

--------------------------------------------------
-- Tree-sitter (preferred)
--------------------------------------------------
set(0, "@function", { fg = accent.func })
set(0, "@method", { fg = accent.func })

set(0, "@keyword", { fg = accent.keyword })

set(0, "@type", { fg = accent.type })
set(0, "@constant", { fg = accent.constant })

-- let Neovim's native cyan handle parameters
set(0, "@variable.parameter", {})

--------------------------------------------------
-- LSP Semantic Tokens (highest priority)
--------------------------------------------------
set(0, "@lsp.type.function", { fg = accent.func })
set(0, "@lsp.type.method", { fg = accent.func })

set(0, "@lsp.type.keyword", { fg = accent.keyword })

set(0, "@lsp.type.type", { fg = accent.type })
set(0, "@lsp.type.parameter", {})

-- readonly: subtle cue, no italics
set(0, "@lsp.mod.readonly", { underline = true })

--------------------------------------------------
-- Macros / preprocessor
--------------------------------------------------
set(0, "Macro", { fg = accent.macro })
set(0, "@macro", { link = "Macro" })
set(0, "@lsp.type.macro", { link = "Macro" })

--------------------------------------------------
-- Diagnostics (clarity without noise)
--------------------------------------------------
set(0, "DiagnosticError", {})
set(0, "DiagnosticWarn", {})

set(0, "DiagnosticUnderlineError", { undercurl = true })
set(0, "DiagnosticUnderlineWarn", { undercurl = true })
set(0, "DiagnosticUnderlineInfo", { undercurl = true })
set(0, "DiagnosticUnderlineHint", { undercurl = true })
