-- 1. Global Enable
vim.opt.list = true

-- 2. State (avoid redundant work)
local state = {
  is_insert = false,
  indent_size = nil,
}

-- 3. Highlight (fast API, cached)
local function set_guide_brightness(is_insert)
  if state.is_insert == is_insert then
    return
  end
  state.is_insert = is_insert

  if is_insert then
    vim.api.nvim_set_hl(0, "Whitespace", { fg = "#2e3440" }) -- ghost
  else
    vim.api.nvim_set_hl(0, "Whitespace", { fg = "#4c566a" }) -- visible
  end
end

-- 4. Indent Guide Generator (cached)
local static_chars = ",tab:»—,trail:×,nbsp:␣"

local function update_indent_guides()
  local sw = vim.bo.shiftwidth
  local size = (sw > 0) and sw or vim.bo.tabstop
  if size <= 0 then
    size = 4
  end

  -- Avoid recomputation if unchanged
  if state.indent_size == size then
    return
  end
  state.indent_size = size

  local guide_char = "•"
  local spaces = string.rep(" ", size - 1)
  local dynamic = guide_char .. spaces

  vim.opt_local.listchars = "leadmultispace:"
    .. dynamic
    .. ",multispace:"
    .. dynamic
    .. static_chars
end

-- 5. Autocommands (minimal set)

-- Mode switching (no redundant calls)
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    set_guide_brightness(true)
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    set_guide_brightness(false)
  end,
})

-- File initialization (lean triggers only)
vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
  callback = function()
    update_indent_guides()
    set_guide_brightness(false)
  end,
})
