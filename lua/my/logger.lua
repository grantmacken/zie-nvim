local M = {}

local myLogPath = vim.fn.stdpath("data") .. "/my.log"

M.log = function(msg)
  local fp = io.open( myLogPath, "a")
  fp:write(string.format("[%-6s%s] %s\n", 'INFO', os.date(), msg))
  fp:close()
end

M.clear = function()
  if vim.loop.fs_stat(myLogPath) then
  local fp = io.open( myLogPath, "w")
  fp:write('')
  fp:close()
  end
end

return M
