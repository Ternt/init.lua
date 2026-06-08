return {
  "https://codeberg.org/andyg/leap.nvim",
  config = function()
    local map = vim.keymap.set

    vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
    vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')  
  end,
}
