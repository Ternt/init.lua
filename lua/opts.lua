local o = vim.o

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
o.shiftwidth        = 2             -- size of indentation
o.softtabstop       = 2
o.expandtab         = true          -- expand tabs out to spaces

-- [[ search ]]
o.smartcase         = true          -- ignores casing when pattern is all lowercase
o.hlsearch          = false         -- highlight all matches
o.incsearch         = true          -- highlight patterns during typing

-- [[ gui options ]]
o.guicursor         = "n-v-c-ve:block,i-ci:hor20"

-- [[ neovide configuration ]]
local g = vim.g
if vim.g.neovide then
  g.neovide_cursor_unfocused_outline_width  = 0.125
  g.neovide_cursor_short_animation_length   = 0.01
  g.neovide_cursor_animation_length         = 0.03
  g.neovide_cursor_trail_size               = 1.0
  g.neovide_refresh_rate                    = 165
  g.neovide_fullscreen                      = true
  g.neovide_scale_factor                    = 0.8
end

