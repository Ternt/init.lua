local map = vim.keymap.set
local del = vim.keymap.del

vim.g.mapleader = "m"

map("n",  "<S-j>",       "}",           { remap = false })
map("n",  "<S-k>",       "{",           { remap = false })
map("n",  "<A-S-j>",     "]]",          { remap = false })
map("n",  "<A-S-k>",     "[[",          { remap = false })
map("n",  "<S-l>",       "$",           { remap = false })
map("n",  "<S-h>",       "^",           { remap = false })

map("n",  "<leader>nl",  "<S-j>",       { remap = false })
map("n",  "<leader>sv",  "<C-w>v",      { desc = "[S]plit [V]ertically" })
map("n",  "<leader>sh",  "<C-w>s",      { desc = "[S]plit [H]orizontally" })
map("n",  "<leader>se",  "<C-w>=",      { desc = "Make Split Windows [=]equal width" })
map("n",  "<leader>sx",  ":close<CR>",  { desc = "Current [S]plit [X]Close" })

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

