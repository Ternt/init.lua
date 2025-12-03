return {
  "chaoren/vim-wordmotion",
  init = function()
    vim.g.wordmotion_mappings = { k = "k", gk = "gk" }
  end
}
