vim.g.mapleader = " "

local keymap = vim.keymap
local map = vim.api.nvim_set_keymap

-- remapping pane motions
map('n', '<C-h>', '<C-W>h', { noremap = true }) 
map('n', '<C-l>', '<C-W>l', { noremap = true }) 
map('n', '<C-k>', '<C-W>k', { noremap = true }) 
map('n', '<C-j>', '<C-W>j', { noremap = true }) 
