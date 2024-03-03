local M = {}
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

M.new_scratch_buffer = function() 
  local buf_id = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buf_id)
  return buf_id
end


M.config = {
  -- Whether to set Vim's settings for b
  set_vim_settings = true,
  -- Whether to disable showing non-error feedback
  silent = true,
}

M.mappings = function()
-- b is for 'buffer'
nmap_leader('ba', '<Cmd>b#<CR>',                                 '[buffer] Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',         '[buffer] Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>',  '[buffer] Delete!')
nmap_leader('bs', '<Cmd>lua require("plugins.buffer").new_scratch_buffer()<CR>',    '[buffer] New Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>',        '[buffer] Wipeout')
end

return M
