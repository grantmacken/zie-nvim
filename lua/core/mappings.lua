-- Set space as leader key
vim.g.mapleader = " "

-- Helper function
--
local keymap = function(mode, keys, cmd, desc, opts)
  opts = opts or {}
  opts.desc = desc
  if opts.silent == nil then opts.silent = true end
  vim.keymap.set(mode, keys, cmd, opts)
end

local nmap = function( keys, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  if opts.silent == nil then opts.silent = true end
  vim.keymap.set('n', keys, rhs, opts)
end

local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-completion.txt
--To get more consistent behavior of `<CR>`, you can use this template in your 'init.lua' to make customized mapping
local keys = {
    ['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
    ['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
    ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
  }

  _G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      -- If popup is visible, confirm selected item or add new line otherwise
      local item_selected = vim.fn.complete_info()['selected'] ~= -1
      return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
    else
      -- If popup is not visible, use plain `<CR>`. You might want to customize
      -- according to other plugins. For example, to use 'mini.pairs', replace
      -- next line with `return require('mini.pairs').cr()`
      return keys['cr']
    end
  end
vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })

vim.keymap.set("n", "<C-z>", "<Nop>",{silent = true}) -- Disable accidentally pressing Ctrl-Z and suspending Neovim
vim.keymap.set("n", "Q", "<Nop>",{silent = true}) -- Disable ex-mode
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>",{silent = true}) -- ESC to turn off search highlighting
-- Better command history navigation
vim.keymap.set('c', '<C-p>', '<Up>', { silent = false })
vim.keymap.set('c', '<C-n>', '<Down>', { silent = false })

-- BRACKETED

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message' )
keymap('n', ']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message' )

