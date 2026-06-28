-- lua/transpose_words.lua
-- Fast ASCII word transposition for Neovim (Lua 5.1 / LuaJIT)
-- Swaps the two nearest words around the cursor on the current line.

local M = {}

local api = vim.api
local unpack = unpack

local nvim_win_get_cursor = api.nvim_win_get_cursor
local nvim_win_set_cursor = api.nvim_win_set_cursor
local nvim_get_current_line = api.nvim_get_current_line
local nvim_set_current_line = api.nvim_set_current_line

local byte = string.byte
local sub = string.sub

local function is_word_byte(b)
  return b
    and (
      (b >= 48 and b <= 57) -- 0-9
      or (b >= 65 and b <= 90) -- A-Z
      or (b >= 97 and b <= 122) -- a-z
      or b == 95 -- _
    )
end

local function find_prev_word(line, pos)
  local i = pos
  if i < 1 then
    return nil
  end

  while i >= 1 and not is_word_byte(byte(line, i)) do
    i = i - 1
  end
  if i < 1 then
    return nil
  end

  local e = i
  while i >= 1 and is_word_byte(byte(line, i)) do
    i = i - 1
  end

  return i + 1, e
end

local function find_next_word(line, pos, len)
  local i = pos
  while i <= len and not is_word_byte(byte(line, i)) do
    i = i + 1
  end
  if i > len then
    return nil
  end

  local s = i
  while i <= len and is_word_byte(byte(line, i)) do
    i = i + 1
  end

  return s, i - 1
end

local function find_word_at(line, pos, len)
  if pos < 1 or pos > len then
    return nil
  end
  if not is_word_byte(byte(line, pos)) then
    return nil
  end

  local s = pos
  local e = pos

  while s > 1 and is_word_byte(byte(line, s - 1)) do
    s = s - 1
  end

  while e < len and is_word_byte(byte(line, e + 1)) do
    e = e + 1
  end

  return s, e
end

local function transpose_line(line, cursor_col)
  local len = #line
  if len < 2 then
    return nil
  end

  local point = cursor_col + 1 -- convert 0-based cursor col to 1-based byte position

  local s1, e1, s2, e2
  local ch = byte(line, point)

  if is_word_byte(ch) then
    -- Cursor is on a word: swap current word with previous one if possible,
    -- otherwise swap with the next one.
    s2, e2 = find_word_at(line, point, len)
    if not s2 then
      return nil
    end

    s1, e1 = find_prev_word(line, s2 - 1)
    if not s1 then
      s1, e1 = s2, e2
      s2, e2 = find_next_word(line, e2 + 1, len)
      if not s2 then
        return nil
      end
    end
  else
    -- Cursor is between words: swap the nearest word on the left and right.
    s1, e1 = find_prev_word(line, point - 1)
    s2, e2 = find_next_word(line, point, len)

    if not s1 then
      -- Cursor before the first word: swap first two words.
      s1, e1 = find_next_word(line, 1, len)
      if not s1 then
        return nil
      end
      s2, e2 = find_next_word(line, e1 + 1, len)
      if not s2 then
        return nil
      end
    elseif not s2 then
      -- Cursor after the last word: swap last two words.
      s2, e2 = s1, e1
      s1, e1 = find_prev_word(line, s1 - 1)
      if not s1 then
        return nil
      end
    end
  end

  if not s1 or not s2 then
    return nil
  end

  local new_line = sub(line, 1, s1 - 1)
    .. sub(line, s2, e2)
    .. sub(line, e1 + 1, s2 - 1)
    .. sub(line, s1, e1)
    .. sub(line, e2 + 1)

  -- Keep cursor after the transposed region.
  return new_line, e2
end

function M.transpose_words()
  local win = 0
  local row, col = unpack(nvim_win_get_cursor(win))
  local line = nvim_get_current_line()

  local new_line, new_col = transpose_line(line, col)
  if not new_line then
    return
  end

  nvim_set_current_line(new_line)
  nvim_win_set_cursor(win, { row, new_col })
end

return M
