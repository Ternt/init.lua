local M = {}

-- setup options
M.opts = {
  pickers = {
    find_files = {
      theme = 'ivy',
      shorten_path = false,
      previewer = false,
    },
  },
}

-- configuration function
M.setup = function()
  require('telescope').setup(M.opts)

  local map = vim.keymap.set

  map("n", "<leader>f", "<cmd>Telescope find_files<cr>")
  map("", "<C-v>", "<cmd>Telescope select_vertical<cr>")
end

return M
