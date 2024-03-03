 -- https://neovim.io/doc/user/diagnostic.html#diagnostic-structure
-- Diagnostics configuration
local severity = vim.diagnostic.severity

local signs = {
  text = {
    [severity.ERROR] = '',
    [severity.WARN] = '',
  },
  linehl = {
    [severity.ERROR] = 'ErrorMsg',
  },
  numhl = {
    [severity.WARN] = 'WarningMsg',
  },
}

local underline = {
  ['severity'] = {
    min = severity.WARN,
  },
}

local float = {
  source = "always",
  border = "rounded",
  show_header = false,
}

-- Handlers can be configured with
local opts = {
  signs = signs,
  underline = underline,
  virtual_text = true,
  update_in_insert = true,
  severity_sort = true,
  float = float,
}

vim.diagnostic.config(opts)
--- Improve UI
local sign_define = vim.fn.sign_define
sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
-- Navigation
-- ref mini-bracketed
--local map = vim.keymap.set
-- map("n", "<space>z",  vim.diagnostic.setloclist)
-- map("n", "<space>e",  vim.diagnostic.open_float)



