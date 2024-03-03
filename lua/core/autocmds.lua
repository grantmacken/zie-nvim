
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

-- https://neovim.io/doc/user/autocmd.html#autocmd-events

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("check_time"),
  command = "checktime",
})

autocmd("VimLeave", {
  group = augroup("vim_leave"),
  callback = function()
    require('my.logger').clear()
  end,
})

-- Autosave
autocmd({ "InsertLeave", "FocusLost" }, {
  pattern = "<buffer>",
  group = augroup("autosave"),
  command = "silent! write",
})

--[[
====== FILE TYPE ======
--]]

autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
      "PlenaryTestPopup",
      "help",
      "lspinfo",
      "man",
      "notify",
      "qf",
      "query", -- :InspectTree
      "oil",
      "oil_preview",
      "startuptime",
      "tsplayground",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
  })

  autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
  })
  autocmd("FileType", {
    group = augroup("unlist_quickfix"),
    desc = "Unlist quickfix buffers",
    pattern = "qf",
    callback = function() vim.opt_local.buflisted = false end,
  })

-- Enable built-in tree-sitter parsers
autocmd("FileType", {
  group = augroup("ts_built_in"),
  pattern = { "c", "lua", "vim", "help" },
  callback = function(args)
    if args.match == "help" then
      args.match = "vimdoc"
    end
    vim.treesitter.start(args.buf, args.match)
  end,
})

--[[
====== BUFFER EVENTS ======
--]]

  autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

-- -- Sync rocks.nvim on save
-- autocmd("BufWritePost", {
--   pattern = "rocks.toml",
--   command = "Rocks sync",
-- })

--[[
====== TEXT  EVENTS ======
--]]
autocmd("TextYankPost", {
  desc = 'Highlight when yanking (copying) text',
  group = augroup("highlight_yank"),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
  end,
})

--[[
====== INSERT  EVENTS ======
--]]

-- Autosave
-- autocmd({ "InsertEnter" }, {
--   pattern = "<buffer>",
--   callback = function()
--     if vim.g.my_completions ~= true then
--     require('my.completions')
--   end
--   end,
-- })

-- Autosave
autocmd({ "InsertLeave", "FocusLost" }, {
  pattern = "<buffer>",
  command = "silent! write",
})

-- -- Disable numbering, folding and signcolumn in Man pages and terminal buffers
-- local function disable_ui_settings()
--   local opts = {
--     number = false,
--     relativenumber = false,
--     signcolumn = "no",
--     foldcolumn = "0",
--     foldlevel = 999,
--   }
--   for opt, val in pairs(opts) do
--     vim.opt_local[opt] = val
--   end
-- end
--
-- local function start_term_mode()
--   disable_ui_settings()
--   vim.cmd("startinsert!")
-- end
--
-- autocmd({ "BufEnter", "BufWinEnter" }, {
--   pattern = "man://*",
--   callback = disable_ui_settings,
-- })
--
-- autocmd("TermOpen", {
--   pattern = "term://*",
--   callback = start_term_mode,
-- })
--[[
--LSP
--]]

 

--[[
====== LSP FILE TYPES ======
--]]
--To ensure a language server is only started for languages it can handle,
--make sure to call vim.lsp.start() within a FileType autocmd.
-- autocmd("FileType", {
--   pattern = { "lua" },
--   group = augroup("lsp"),
--   callback = function(args)
--    local log = require('my.logger').log
--    log(  'file type: '  .. args.match )
--    log(  'file location: ' .. args.file )
--    local client_id = vim.lsp.start(lua_lsp_conf)
--    log(  'clent id: ' .. client_id )
--   end
-- })


-- https://neovim.io/doc/user/diagnostic.html#diagnostic-events
autocmd('DiagnosticChanged', {
  group = augroup("diag"),
  callback = function(args)
    local log = require('my.logger').log
    local diagnostics = args.data.diagnostics
    log('diagnostics changed')
    -- log(vim.print(diagnostics))
  end,
})

