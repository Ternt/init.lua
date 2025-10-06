local map = vim.keymap.set
local del = vim.keymap.del
local api = vim.api

vim.g.mapleader = " "

map("",  "<S-j>",   "}",        { noremap = true })
map("",  "<S-k>",   "{",        { noremap = true })
map("",  "<S-l>",   "<End>",    { noremap = true })
map("",  "<S-h>",   "<Home>",   { noremap = true })

map("",   "<C-j>",   ":wincmd j<CR>")
map("",   "<C-k>",   ":wincmd k<CR>")
map("",   "<C-l>",   ":wincmd l<CR>")
map("",   "<C-h>",   ":wincmd h<CR>")

api.nvim_create_autocmd('TextYankPost', {
  group = api.nvim_create_augroup('custom-highlight-yank', { clear = false }),
  callback = function()
    vim.highlight.on_yank()
  end
})

api.nvim_create_autocmd('TermOpen', {
  group = api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
})

