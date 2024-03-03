
local M = {}
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end


-- Toggle quickfix window
M.toggle_quickfix = function()
  local quickfix_wins = vim.tbl_filter(
    function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
    vim.api.nvim_tabpage_list_wins(0)
  )
  local command = #quickfix_wins == 0 and 'copen' or 'cclose'
  vim.cmd(command)
end


M.config = { windows = { preview = true } }

M.mappings = function()
-- e is for 'explore' and 'edit'
nmap_leader('ec', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<CR>',                                  '[explore] Config')
nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>',                                                          'Directory')
nmap_leader('ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>',                              'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>',                                                                 'File directory')
nmap_leader('em', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/start/mini.nvim")<CR>', 'Mini.nvim directory')
nmap_leader('ep', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/opt")<CR>',             'Plugins directory')
end

return M
