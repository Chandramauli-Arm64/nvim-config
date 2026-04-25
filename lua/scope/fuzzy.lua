-- lua/scope/fuzzy.lua

local M = {}

function M.match(query, items)
  local results = {}

  for _, item in ipairs(items) do
    if string.find(string.lower(item), string.lower(query), 1, true) then
      table.insert(results, item)
    end
  end

  return results
end

return M
