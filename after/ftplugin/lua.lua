local lua_lsp_conf = {
  name = 'lua_ls', --Name in log messages
  cmd = { 'lua-language-server' },
  root_dir = vim.fs.dirname(vim.fs.find({'.git','Makefile'}, { upward = true })[1]),
  workspace_folders = nil,
  -- before_init = beforeInit,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global, etc.
        globals = {
          'MiniCompletion',
          'MiniDeps',
          'MiniExtra',
          'MiniMisc',
          'MiniNotify',
          'MiniPick',
          'vim',
        },
        disable = {
          'duplicate-set-field',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
        },
      },
      telemetry = {
        enable = false,
      },
      hint = { -- inlay hints
        enable = true,
      },
    },
  },
}

-- optional keyword arguments
local lua_lsp_opts = {
  bufnr = 0 -- (number)  Buffer handle to attach to if starting or re-using a client (0 for current). 
}

local log = require('my.logger').log
-- log(  'file type: '  .. args.match )
-- log(  'file location: ' .. args.file )
local client_id = vim.lsp.start(lua_lsp_conf)
log(  'clent id: ' .. client_id )


