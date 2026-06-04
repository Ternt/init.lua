local map = vim.keymap.set
local del = vim.keymap.del

vim.g.mapleader = "m"

map({ "n", "v" }, "<leader>nl", "<S-j>", { noremap = true })
map({ "n", "v" }, "<S-j>",      "}",     { noremap = true })
map({ "n", "v" }, "<S-k>",      "{",     { noremap = true })
map({ "n", "v" }, "<A-S-j>",    "]]",    { noremap = true })
map({ "n", "v" }, "<A-S-k>",    "[[",    { noremap = true })
map({ "n", "v" }, "<S-l>",      "$",     { noremap = true })
map({ "n", "v" }, "<S-h>",      "_",     { noremap = true })

map("n", "<A-j>", ":m .+1<CR>==",     { noremap = true })
map("n", "<A-k>", ":m .-2<CR>==",     { noremap = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true })

map("n",  "<leader>wk",  "<C-w>k",      {  })
map("n",  "<leader>wj",  "<C-w>j",      {  })
map("n",  "<leader>wl",  "<C-w>l",      {  })
map("n",  "<leader>wh",  "<C-w>h",      {  })
map("n",  "<leader>sv",  "<C-w>v",      { desc = "[S]plit [V]ertically" })
map("n",  "<leader>sh",  "<C-w>s",      { desc = "[S]plit [H]orizontally" })
map("n",  "<leader>se",  "<C-w>=",      { desc = "Make Split Windows [=]equal width" })
map("n",  "<leader>sx",  ":close<CR>",  { desc = "Current [S]plit [X]Close" })

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
-- map("n", "yc", "yy<cmd>normal gcc<CR>p", { noremap = true, desc = "Duplicate line and comment original" })
-- map("v", "yc", function()
--   local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
--   vim.api.nvim_feedkeys(esc, "x", false)
--
--   local start_line = vim.fn.line("'<")
--   local end_line = vim.fn.line("'>")
--
--   vim.cmd(start_line .. "," .. end_line .. "yank")
--   vim.cmd((end_line + 1) .. "put")
--
--   vim.api.nvim_feedkeys("gv", "n", false)
--   vim.api.nvim_feedkeys("gc", "v", false)
-- end, { noremap = true, desc = "Duplicate selection and comment original" })

map("n", "<leader>dd", function()
  if vim.wo.diff then
    vim.cmd("diffoff!")
  else
    vim.cmd("windo diffthis")
  end
end, { noremap = true, desc = "Toggle diff mode" })
