vim.g.mapleader = ' ' -- Use space as the one and only true Leader key
vim.g.maplocalleader = ' '

vim.cmd('filetype plugin indent on') -- Enable all filetype plugins
local opt = vim.opt
opt.autowrite      = true -- Enable auto write
opt.backup         = false -- Don't store backup while overwriting the file
opt.breakindent    = true    -- Indent wrapped lines to match line start
opt.clipboard      = "unnamedplus" -- Sync with system clipboard
opt.cmdheight = 0 -- hide command line unless needed
opt.completeopt    = 'menuone,noinsert,noselect' -- Customize completions
opt.conceallevel   = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm        = true -- Confirm to save changes before exiting modified buffer
opt.cursorline     = true    -- Highlight current line
opt.colorcolumn    = "120"
opt.expandtab      = true -- Use spaces instead of tabs
opt.fillchars      = {foldopen = "",foldclose = "",fold = " ",foldsep = " ",diff = "╱",eob = " ",}
opt.formatoptions  = 'qjl1'                      -- Don't autoformat comments
opt.grepformat     = "%f:%l:%c:%m"
opt.grepprg        = "rg --vimgrep"
-- opt.guicursor      = ''
opt.hlsearch = true
opt.ignorecase     = true -- Ignore case when searching (use `\C` to force not doing that)
opt.inccommand     = "split" -- preview incremental substitute
opt.incsearch      = true -- Show search results while typing
opt.infercase      = true -- Infer letter cases for a richer built-in keyword completion
opt.laststatus     = 3 -- global statusline
opt.linebreak      = true    -- Wrap long lines at 'breakat' (if 'wrap' is set)
opt.list           = true -- Show some invisible characters (tabs...
opt.listchars      = 'tab:> ,extends:…,precedes:…,nbsp:␣' -- Define which helper symbols to show
opt.mouse          = 'a'   -- Enable mouse for all available modes
opt.number         = true  -- Show line numbers
opt.pumblend       = 10 -- Make builtin completion menus slightly transparent
opt.pumheight      = 10 -- Make popup menu smaller
opt.relativenumber = true -- Relative line numbers
opt.ruler          = false   -- Don't show cursor position in command line
opt.scrolloff      = 10 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround     = true -- Round indent
opt.shiftwidth     = 2 -- Size of an indent
opt.shortmess:append('WcC') -- Reduce command line messages
opt.showmode      = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn    = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase     = true -- Don't ignore case when searching if pattern has upper case
opt.smartcase     = true -- Don't ignore case with capitals
opt.smartindent   = true -- Insert indents automatically
opt.smoothscroll  = true
opt.spelllang     = { "en" }
opt.splitbelow    = true -- Put new windows below current
opt.splitkeep     =  "screen"
opt.splitright    = true -- Put new windows right of current
opt.tabstop       = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen    = 300
opt.undofile      = true  -- Enable persistent undo (see also `:h undodir`)
opt.undolevels    = 10000
opt.updatetime    = 250 -- Save swap file and trigger CursorHold
opt.virtualedit   = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode      = "longest:full,full" -- Command-line completion mode
opt.winblend      = 10 -- Make floating windows slightly transparent
opt.winminwidth   = 5 -- Minimum window width
opt.wrap          = false   -- Display long lines as just one line
opt.writebackup   = false -- Don't store backup while overwriting the file

vim.opt.foldlevel = 99
-- TODO!
-- vim.opt.foldtext = "v:lua.require'ak.util'.ui.foldtext()"
-- vim.opt.statuscolumn = [[%!v:lua.require'ak.util'.ui.statuscolumn()]]
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.require'ak.util'.ui.foldexpr()"
-- vim.opt.foldmethod = "indent"
--

--opt.shortmess:append({ W = true, I = true, c = true, C = true })
--
--
-- opt.formatoptions  = "jcroqlnt" -- tcqj
--opt.fillchars      = 'eob: ' -- Don't show `~` outside of buffer
--
-- opt.completeopt = "menu,menuone,noselect"
