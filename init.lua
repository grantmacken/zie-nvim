-- for _, disable in ipairs({ "gzip", "netrwPlugin", "tarPlugin", "zipPlugin" }) do
--   vim.g["loaded_" .. disable] = 0
-- end
for _, provider in ipairs({ "perl", "ruby", "node", "python3" }) do
  vim.g["loaded_" .. provider .. '_provider' ] = 0
end
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end
-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
--[[ SETTINGS AND MAPPINGS 
 - options
 - autocommands
 - key binds
]]--
now( function()
  require('core')
end )
--[[ mini.nvim ]]--
add({ name = 'mini.nvim', checkout = 'HEAD' })
--[[ STEP ONE ]]
----Safely execute immediately
-- Use external plugins with `add()`
now(function()
  local filterout_lua_diagnosing = function(notif_arr)
    local not_diagnosing = function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end
    notif_arr = vim.tbl_filter(not_diagnosing, notif_arr)
    return MiniNotify.default_sort(notif_arr)
  end
  require('mini.notify').setup({
    content = { sort = filterout_lua_diagnosing },
    window = { config = { border = 'double' } },
  })
  vim.notify = MiniNotify.make_notify()
end)


later( function()
	vim.cmd("colorscheme kanagawa")
	require('mini.basics').setup({
		options = {
			-- Basic options ('number', 'ignorecase', and many more)
			basic = false,
			-- Extra UI features ('winblend', 'cmdheight=0', ...)
			extra_ui = false,
			-- Presets for window borders ('single', 'double', ...)
			win_borders = 'default', },
		mappings = {
			-- Basic mappings (better 'jk', save with Ctrl+S, ...)
			basic = true,
			-- Supply empty string to not create these mappings.
			option_toggle_prefix = [[,]],
			-- Window navigation with <C-hjkl>, resize with <C-arrow>
			windows = true,
			-- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
			move_with_alt = true,
		},
		-- Autocommands. Set to `false` to disable
		autocommands = {
			-- Basic autocommands (highlight on yank, start Insert in terminal, ...)
			basic = true,
			-- Set 'relativenumber' only in linewise and blockwise Visual mode
			relnum_in_visual_mode = true,
		},
	})
end )



now(function() require('mini.sessions').setup({}) end)
now(function() require('mini.starter').setup() end)

now(function()
  --require('nvim-web-devicons').setup()
  local statusline = require('mini.statusline')
  -- TODO https://github.com/echasnovski/nvim/blob/master/init.lua
  statusline.setup({
    use_icons = true,
    set_vim_settings = false,
  }) end)

now(function() require('mini.tabline').setup() end)
--[[ STEP TWO ]]--
-- Safely execute later
later(function() require('mini.extra').setup() end)
later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    },
  })
end)
later(function() require('mini.align').setup() end)
later(function()require('mini.bracketed').setup({})end)

later(function()
  local plugin = require('plugins.buffer')
  require('mini.bufremove').setup(plugin.config)
  plugin.mappings()
end)


later(function()
-- TODO! https://github.com/echasnovski/nvim/blob/master/init.lua
local miniclue = require('mini.clue')
  miniclue.setup({
  triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },
      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      -- Window commands
      { mode = 'n', keys = '<C-w>' },
      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
}) end)

later(function() require('mini.comment').setup() end)

later(function()
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        -- Don't show 'Text' and 'Snippet' suggestions
        items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
        return MiniCompletion.default_process_items(items, base)
      end,
    },
    window = {
      info = { border = 'double' },
      signature = { border = 'double' },
    },
  })
end)

later(function() require("mini.cursorword").setup() end)

later(function()
  local plugin = require('plugins.edit')
  require('mini.files').setup(plugin.config)
  plugin.mappings()
  -- local minifiles_augroup = vim.api.nvim_create_augroup('ec-mini-files', {})
  -- vim.api.nvim_create_autocmd('User', {
  --   group = minifiles_augroup,
  --   pattern = 'MiniFilesWindowOpen',
  --   callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
  -- })
end)

--
later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function() require("mini.indentscope").setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.jump2d').setup({ view = { dim = true } }) end)


later(function()
  local map = require('mini.map')
  local gen_integr = map.gen_integration
  local encode_symbols = map.gen_encode_symbols.block('3x2')
  -- Use dots in `st` terminal because it can render them as blocks
  if vim.startswith(vim.fn.getenv('TERM'), 'st') then encode_symbols = map.gen_encode_symbols.dot('4x2') end
  map.setup({
    symbols = { encode = encode_symbols },
    integrations = { gen_integr.builtin_search(), gen_integr.gitsigns(), gen_integr.diagnostic() },
  })
  for _, key in ipairs({ 'n', 'N', '*' }) do
    vim.keymap.set('n', key, key .. 'zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>')
  end
end)

later(function()
  require('mini.misc').setup({ make_global = { 'put', 'put_text', 'stat_summary', 'bench_time' } })
  MiniMisc.setup_auto_root()
end)
later(function() require('mini.move').setup({ options = { reindent_linewise = false } }) end)
later(function() require('mini.operators').setup() end)

-- later(function()
--   require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = true } })
--   vim.keymap.set('i', '<CR>', 'v:lua.Config.cr_action()', { expr = true })
-- end(config
later(function()
  local plugin = require('plugins.pick')
  require('mini.pick').setup(plugin.config)
  vim.ui.select = MiniPick.ui_select
  plugin.mappings()
end)
later(function() require('mini.splitjoin').setup() end)
later(function()
  require('mini.surround').setup({ search_method = 'cover_or_next' })
  -- Disable `s` shortcut (use `cl` instead) for safer usage of 'mini.surround'
  vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
end)

later(function() require("mini.trailspace").setup() end)

--[[  DEPENDENCIES ]]--
--
now(function()
	-- Add to current session (install if absent)
	add({
		source = 'rebelot/kanagawa.nvim',
		checkout = 'master',
	})
end)
-- the following adds are for the status line
now(function()
  add({
    source = 'nvim-tree/nvim-web-devicons',
    checkout = 'master',
  })
end )
later(function()
 add({
   source = 'lewis6991/gitsigns.nvim',
   checkout = 'main',
   })
  local plugin = require('plugins.git')
  require('gitsigns').setup(plugin.config)
  plugin.mappings()
end)

now(function()
 add({
   source = 'nvim-lua/plenary.nvim',
    checkout = 'master',
   })
end )

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require('nvim-treesitter.configs').setup({
    ensure_installed = {},
    highlight = { enable = true },
  })
end)

later(function()
  add({
    source = 'stevearc/oil.nvim',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    -- monitor = 'main',
    -- Perform action after every checkout
    hooks = { },
  })
  require('oil').setup({
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,}})
  vim.keymap.set('n', '-', function() vim.cmd.Oil() end, { desc = '[oil] open parent directory' })
end)

later(function()
  add({
    source = 'stevearc/overseer.nvim',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    hooks = { },
  })
  -- TODO!
end)

later(function()
  add({
    source = 'stevearc/conform.nvim',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    hooks = { },
  })
  -- TODO!
end)

later(function()
  add({
    source = 'L3MON4D3/LuaSnip',
    checkout = 'master',
    hooks = {'make install_jsregexp'},
  })
  -- TODO!
  --require('conform').setup({})
end)

later(function()
  add({
    source = 'ThePrimeagen/harpoon',
    checkout = 'harpoon2',
    hooks = { },
  })
  local plugin = require('plugins.harpoon')
  plugin.setup()
  plugin.mappings()
end)

later(function()
  add({
    source = 'akinsho/toggleterm.nvim',
    checkout = 'main',
    hooks = { },
  })
  local plugin = require('plugins.terminal')
  require('toggleterm').setup(plugin.config)
  plugin.mappings()
end)

later(function()
  add({
    source = 'folke/trouble.nvim',
    checkout = 'main',
    hooks = { },
  })
  local plugin = require('plugins.trouble')
  require('trouble').setup(plugin.config)
  plugin.mappings()
end)

later(function()
  add({
    source = 'mikesmithgh/kitty-scrollback.nvim',
    checkout = 'main',
    hooks = { },
  })
  -- local plugin = require('plugins.trouble')
  -- require('trouble').setup(plugin.config)
  -- plugin.mappings()
end)


