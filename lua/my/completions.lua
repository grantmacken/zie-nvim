vim.g.my_completions = true
vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
local cmp = require('cmp')
local luasnip = require 'luasnip'
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local function complete_with_source(source)
  if type(source) == 'string' then
    cmp.complete { config = { sources = { { name = source } } } }
  elseif type(source) == 'table' then
    cmp.complete { config = { sources = { source } } }
  end
end

local function complete_with_source_mapping(name, modes)
  return cmp.mapping.complete { config = { sources = { { name = name } } }, modes }
end

local lspKindFormat = require('lspkind').cmp_format {
  mode = 'symbol_text',
  with_text = true,
  maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
  ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
  menu = {
    buffer = '[BUF]',
    nvim_lsp = '[LSP]',
    nvim_lsp_signature_help = '[LSP]',
    nvim_lsp_document_symbol = '[LSP]',
    nvim_lua = '[API]',
    path = '[PATH]',
    luasnip = '[SNIP]',
    luasnip_choice = '[CHOICE]',
    rg = '[RG]',
    cmdline = '[CMD]',
    cmdline_history = '[HISTORY]',
    cmp_git = '[GIT]',
    tmux = '[TMUX]',
  },
}

local mapOpts = { 'i', 'c', 's' }

local cmpBuffer = cmp.mapping(function(_)
    if cmp.visible() then
      cmp.scroll_docs(-4)
    else
      complete_with_source('buffer')
    end
  end, mapOpts)

local cmpPath = cmp.mapping(function(_)
    if cmp.visible() then
      cmp.scroll_docs(-4)
    else
      complete_with_source('async_path')
    end
  end, mapOpts)

  local cmpNext = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- expand_or_jumpable(): Jump outside the snippet region
      -- expand_or_locally_jumpable(): Only jump inside the snippet region
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
  end, mapOpts)

  local cmpConfirm = cmp.mapping(function(_)
    cmp.confirm {
      select = true,
    }
  end, mapOpts)

local cmpToggle = cmp.mapping(function(_)
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete()
  end
end, mapOpts )

local cmpPrev = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
  end, mapOpts)

local snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  }

mapping = {
  ['<C-b>'] = cmpBuffer,
  ['<C-f>'] = cmpPath,
  ['<C-n>'] = cmpNext,
  ['<C-p>'] = cmpPrev,
  ['<C-y>'] = cmpConfirm,
  ['<C-e>'] = cmpToggle
}
local sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer'},
    { name = 'async_path' },
}

  cmp.setup({
    completion = {
      completeopt = 'menu,menuone,noinsert',
      autocomplete = false,
    },
    formatting = { format = lspKindFormat},
    snippet = snippet,
    sources = sources,
    mapping = mapping,
    experimental = {
      native_menu = false,
      ghost_text = {
        hl_group = "CmpGhostText",
      },
    }
  })



