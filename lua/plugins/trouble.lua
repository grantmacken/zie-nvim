local M = {}
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

-- M.new_scratch_buffer = function() 
--
-- end
-- plugin setup config options
M.config = {
}

-- plugin leader mappings
M.mappings = function()
-- x is for 'trouble'
nmap_leader('xx', function() require("trouble").toggle() end,'[trouble] toggle')
nmap_leader('xw', function() require("trouble").toggle('workspace_diagnostics') end,'[trouble] toggle workspace diagnostics')
nmap_leader('xd', function() require("trouble").toggle('document_diagnostics') end,'[trouble] toggle document diagnostics')
nmap_leader('xq', function() require("trouble").toggle('quickfix') end,'[trouble] toggle quickfix')
nmap_leader('xl', function() require("trouble").toggle('loclist') end,'[trouble] toggle loclist')
nmap_leader('xgR', function() require("trouble").toggle('lsp_references') end,'trouble] LSP references')
end
return M
