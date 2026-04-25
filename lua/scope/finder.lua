-- lua/scope/finder.lua

local M = {}

function M.fd_files(callback)
  vim.system(
    { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
    { text = true },
    function(obj)
      local results = {}

      for line in obj.stdout:gmatch("[^\n]+") do
        table.insert(results, line)
      end

      vim.schedule(function()
        callback(results)
      end)
    end
  )
end

return M
