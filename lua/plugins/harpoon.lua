
local M = {}
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

local harpoon =require('harpoon')

-- plugin setup config options
local config = {
    settings = {
    save_on_toggle = true,
  }
}

-- plugin init
M.setup = function()
harpoon.setup(config)
end

-- plugin leader mappings
M.mappings = function()
-- h is for 'harpoon'
nmap_leader('ha', function() harpoon:list():append() end,'[harpoon] Append')
nmap_leader('hm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end ,'[harpoon] Menu')
nmap_leader('hp', function() harpoon:list():prev() end,'[harpoon] Previous')
nmap_leader('hn', function() harpoon:list():next() end,'[harpoon] Next')
nmap_leader('h1', function() harpoon:list():select(1) end,'[harpoon] One')
nmap_leader('h2', function() harpoon:list():select(2) end,'[harpoon] Two')
nmap_leader('h3', function() harpoon:list():select(3) end,'[harpoon] Three')
nmap_leader('h4', function() harpoon:list():select(4) end,'[harpoon] Four')
end

return M
