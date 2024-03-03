
local M = {}
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

local open_mapping = [[<c-\>]]

-- plugin setup config options
M.config = {
  size = function(term)
    if term.direction == 'horizontal' then
      return 10
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = false,
  auto_scroll = false,
  -- This field is only relevant if direction is set to 'float'
  autochdir = false,
  winbar = {
    enabled = true,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}

local lazygit = require("toggleterm.terminal").Terminal:new({
  cmd = "lazygit",
  count = 99,
  hidden = true,
  direction = "tab" })
--
-- vim.keymap.set(", "<leader>mt", function() vim.cmd("ToggleTermToggleAll") end, {
--   desc = "ToggleTerm all",
--   silent = true,
-- })

-- plugin leader mappings
M.mappings = function()
-- t is for 'terminal'
local opts = { noremap = true, silent = true }
nmap_leader("tg", function() lazygit:toggle() end, '[terminal] Lazygit' ,opts )
end

return M
