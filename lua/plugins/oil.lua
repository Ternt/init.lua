return   {
  'stevearc/oil.nvim',
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  lazy = false,
  config = function()
    require('oil').setup()

    vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end
}
