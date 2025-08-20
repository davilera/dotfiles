local M = {}

function M.require_dir(dir)
  local files = vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/" .. dir, function(name)
    if name:match("%.lua$") ~= nil then
      return 1
    else
      return 0
    end
  end)

  for _, file in ipairs(files) do
    local mod = file:gsub("%.lua$", "")
    require(dir:gsub("/$", ""):gsub("/", ".") .. "." .. mod)
  end
end

return M
