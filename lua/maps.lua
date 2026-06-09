local helpers = require('helpers')
local map = vim.keymap.set
local del = vim.keymap.del
vim.g.mapleader = "m"

map({ "n", "v" }, "<leader>nl", "<S-j>", { noremap = true })
map({ "n", "v" }, "<S-l>",      "$",     { noremap = true })
map({ "n", "v" }, "<S-h>",      "_",     { noremap = true })

map({ "n", "x" }, "<S-j>", function() helpers.scope_jump(1)  end, { noremap = true })
map({ "n", "x" }, "<S-k>", function() helpers.scope_jump(-1) end, { noremap = true })

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

map("n",  "<leader>wk",  "<C-w>k")
map("n",  "<leader>wj",  "<C-w>j")
map("n",  "<leader>wl",  "<C-w>l")
map("n",  "<leader>wh",  "<C-w>h")
map("n",  "<leader>se",  "<C-w>=")
map("n",  "<leader>sx",  ":close<CR>")
map("n",  "<leader>sv", function() helpers.smart_split(true)  end)
map("n",  "<leader>sh", function() helpers.smart_split(false) end)

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

map(
  "n", 
  "gef", 
  helpers.generate_enum_flags,
  { desc = "[g]enerate [e]num [f]lags" }
)

map(
  "n", 
  "gfd", 
  helpers.expand_function_declaration, 
  { desc = "[g]enerate [f]unction [d]efinition" }
)
