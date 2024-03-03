
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
--[[
====== LSP EVENTS ======
Defaults are set when LSP client starts 
 - enables diagnostics 
 - 'omnifunc' is set to vim.lsp.omnifunc(), use i_CTRL-X_CTRL-O to trigger completion. 
 - 'formatexpr' is set to vim.lsp.formatexpr(), so you can format lines via gq if the language server supports it. 
 - K is mapped to vim.lsp.buf.hover() unless 'keywordprg' is customized or a custom keymap for K exists. 
--]]
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

autocmd("LspAttach", {
    callback = function(args)
      local log = require('my.logger').log
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- Enable omnifunc-completion
      log('Lang Server attached buffer: ' .. bufnr)
        --log('Lang Server client ID: ' .. client.id)
        --log('Lang Server name: ' .. client.name)
        --  :lua =vim.lsp.get_clients()[1].server_capabilities
      local capabilities = client.server_capabilities
      local setBufOpts = function(description) 
        return { noremap = true, silent = true, buffer = bufnr }
       end
        
      -- NOTE: set buffer options and key maps based on capablities
      -- COMPLETIONS
      if capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
        vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true, buffer = bufnr})
        vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, buffer = bufnr })
      end
      -- I use this to set per buffer key maps
      -- SYMBOLS
      -- symbol under cursor
      if capabilities.hoverProvider then
        vim.keymap.set('n', 'K', vim.lsp.buf.hover,setBufOpts('Hover Documentation'))
      end
      -- DEFINITIONS && DECLARATIONS
      if capabilities.definitionProvider then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,setBufOpts('Hover Documentation'))
      end
      if capabilities.typeDefinitionProvider then
        vim.keymap.set("n", "go", vim.lsp.buf.definition,setBufOpts('Definition'))
      end
      if capabilities.declarationProvider then
        vim.keymap.set("n", "gD", vim.lsp.buf.definition,setBufOpts('Declaration'))
      end
    -- RENAMING
      if capabilities.renameProvider then
        vim.keymap.set({ "n" }, "<F2>", vim.lsp.buf.rename, setBufOpts('Rename'))
      end
    -- FORMATING
     if capabilities.documentFormattingProvider then
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --   group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
        --   buffer = bufnr,
        --   callback = function()
        --     vim.lsp.buf.format({ async = true })
        --   end
        -- })
        vim.keymap.set("n", "<F3>", vim.lsp.buf.format, setBufOpts('Format'))
      end

     if capabilities.codeActionProvider then
        vim.keymap.set({ "n" }, "<F4>", vim.lsp.buf.code_action, setBufOpts('Code Actions'))
      end
    end,
})
