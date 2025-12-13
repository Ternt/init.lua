local o = vim.o

vim.cmd.filetype("on")
vim.cmd.filetype("plugin on")


-- [[ appearance ]]
o.numberwidth       = 4             -- width of number line
o.wrap              = false
o.termguicolors     = true

-- [[ text editing ]]
o.number            = true          -- number line
o.relativenumber    = true          -- relative number line
o.cursorline        = false         -- cursor line
o.splitbelow        = true
o.splitright        = true
vim.opt.swapfile    = false
vim.opt.backup      = false
vim.opt.undofile    = true

-- [[ identation and tabstops ]]
o.autoindent        = true          -- insert indents automatically
o.smartindent       = true          -- autoidenting when starting a new line
o.smarttab          = true          -- indent by shiftwidth if in leading whitespace
o.expandtab         = true          -- expand tabs out to spaces
o.shiftwidth        = 2             -- size of indentation
o.softtabstop       = 2

-- [[ search ]]
o.smartcase         = true          -- ignores casing when pattern is all lowercase
o.hlsearch          = false         -- highlight all matches
o.incsearch         = true          -- highlight patterns during typing

-- [[ gui options ]]
o.guicursor         = "n-v-c-ve:block,i-ci:hor20"
o.scrolloff         = 0
