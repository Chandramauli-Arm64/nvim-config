-- 1. Global Enable
vim.opt.list = true

-- 2. The Ghost/Brightness Function
-- Normal mode = 244 (visible grey), Insert mode = 234 (deep ghost)
local function set_guide_brightness(is_insert)
  if is_insert then
    vim.cmd([[highlight Whitespace guifg=#2e3440 ctermfg=234]])
  else
    -- Using 244 for better Normal mode visibility as per your feedback
    vim.cmd([[highlight Whitespace guifg=#4c566a ctermfg=244]])
  end
end

-- 3. Dynamic Scaling Logic (Handles 2-4 spaces & EditorConfig)
local function update_indent_guides()
  local sw = vim.bo.shiftwidth
  local space_count = (sw > 0) and sw or vim.bo.tabstop
  if space_count <= 0 then
    space_count = 4
  end

  local guide_char = "·"
  local spaces = string.rep(" ", space_count - 1)
  local dynamic_guide = guide_char .. spaces

  -- Universal Package for Accuracy (catches tabs, trailing spaces, and NBSPs)
  local str = table.concat({
    "leadmultispace:" .. dynamic_guide,
    "multispace:" .. dynamic_guide,
    "tab:»—",
    "trail:×",
    "nbsp:␣",
  }, ",")

  vim.opt_local.listchars = str
end

-- 4. Mode-Switching Observers (The Ghost Effect)
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    set_guide_brightness(true)
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    set_guide_brightness(false)
  end,
})

-- 5. The Initialization Observer (Handles pre-existing files and LSPs)
vim.api.nvim_create_autocmd(
  { "BufEnter", "BufReadPost", "FileType", "LspAttach" },
  {
    callback = function()
      update_indent_guides()
      set_guide_brightness(false)
      -- Force a redraw so guides appear immediately on file open
      vim.cmd("redraw")
    end,
  }
)
