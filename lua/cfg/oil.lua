local M = {}

-- setup options
M.opts = {
}

-- configuration function
M.setup = function()
  require('oil').setup(M.opts)

  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end

return M
