local M = {}


M.get_session_name = function()
  local name = vim.fn.getcwd()
  local branch = vim.trim(vim.fn.system("git branch --show-current"))
  if vim.v.shell_error == 0 then
    return name .. '_' .. branch
  else
    return name
  end
end

-- This indicates that oil.nvim should be shown
 M.opened_with_dir_argument = function() 
  if vim.fn.argc() == 1 then
    local stat = vim.loop.fs_stat(vim.fn.argv(0))
    if stat and stat.type == "directory" then return true end
  end
  return false
end

return M
