local map = vim.keymap.set
local del = vim.keymap.del
vim.g.mapleader = "m"

map({ "n", "v" }, "<leader>nl", "<S-j>", { noremap = true })
map({ "n", "v" }, "<S-l>",      "$",     { noremap = true })
map({ "n", "v" }, "<S-h>",      "_",     { noremap = true })

-- jump to next/prev empty line
map({ "n", "x" }, "<A-j>", "}",  { noremap = true, })
map({ "n", "x" }, "<A-k>", "{",  { noremap = true, })

-- line moving (pick new keys since Alt is taken)
map("n", "<A-S-j>", ":m .+1<CR>==",     { noremap = true })
map("n", "<A-S-k>", ":m .-2<CR>==",     { noremap = true })
map("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { noremap = true })

map("n",  "G",  "Gzz",  { noremap = true })
map("n",  "n",  "nzz",  { noremap = true })
map("n",  "N",  "Nzz",  { noremap = true })
map("n",  "*",  "*zz",  { noremap = true })
map("n",  "#",  "#zz",  { noremap = true })
map("n",  "g*", "g*zz", { noremap = true })
map("n",  "g#", "g#zz", { noremap = true })

map(
  "n",  
  "<leader>pm", 
  "<cmd>Lazy<cr>", 
  { desc = "Open [p]ackage [m]anager" }
)

map(
  "n",
  "<leader>s",
  [[:%s/<C-r><C-w>//gI<Left><Left><Left>]],
  { desc = "open %s//gI with cword" }
)
