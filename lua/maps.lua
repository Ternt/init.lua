local helper = require("helper")
local map = vim.keymap.set
local del = vim.keymap.del

vim.g.mapleader = "m"

map({ "n", "v" }, "<leader>nl", "<S-j>", { noremap = true })
map({ "n", "v" }, "<S-l>",      "$",     { noremap = true })
map({ "n", "v" }, "<S-h>",      "_",     { noremap = true })

-- scope jump
map({ "n", "x" }, "<S-j>", function() helper.scope_jump(1)  end, { noremap = true, desc = "Jump to next scope" })
map({ "n", "x" }, "<S-k>", function() helper.scope_jump(-1) end, { noremap = true, desc = "Jump to previous scope" })

-- jump to next/prev empty line
map({ "n", "x" }, "<A-S-j>", "}",  { noremap = true, desc = "Jump to next empty line" })
map({ "n", "x" }, "<A-S-k>", "{",  { noremap = true, desc = "Jump to prev empty line" })

-- line moving (pick new keys since Alt is taken)
map("n", "<A-j>", ":m .+1<CR>==",     { noremap = true })
map("n", "<A-k>", ":m .-2<CR>==",     { noremap = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true })

map("n",  "<leader>wk",  "<C-w>k",     {  })
map("n",  "<leader>wj",  "<C-w>j",     {  })
map("n",  "<leader>wl",  "<C-w>l",     {  })
map("n",  "<leader>wh",  "<C-w>h",     {  })
map("n",  "<leader>se",  "<C-w>=",     { desc = "Make Split Windows [=]equal width" })
map("n",  "<leader>sx",  ":close<CR>", { desc = "Current [S]plit [X]Close" })
map("n",  "<leader>sv", function() helper.smart_split(true)  end, { desc = "[S]plit [V]ertically" })
map("n",  "<leader>sh", function() helper.smart_split(false) end, { desc = "[S]plit [H]orizontally" })

map("n",  "G",  "Gzz",  { noremap = true, desc = "Go to bottom and center" })
map("n",  "n",  "nzz",  { noremap = true })
map("n",  "N",  "Nzz",  { noremap = true })
map("n",  "*",  "*zz",  { noremap = true })
map("n",  "#",  "#zz",  { noremap = true })
map("n",  "g*", "g*zz", { noremap = true })
map("n",  "g#", "g#zz", { noremap = true })

map("n", "<leader>v", "vg_", { noremap = true, desc = "Select to last non-blank character" })

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

map("n", "yp", "yyp", { noremap = true, desc = "Duplicate line" })

vim.keymap.set(
  "n", 
  "gef", 
  helper.generate_enum_flags,
  { desc = "[g]enerate [e]num [f]lags" }
)
vim.keymap.set(
  "n", 
  "gfd", 
  helper.expand_function_declaration, 
  { desc = "[g]enerate [f]unction [d]efinition" }
)
