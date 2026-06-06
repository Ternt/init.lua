return {
  'stevearc/oil.nvim',
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  lazy = false,
  config = function()
    require('oil').setup({
      use_default_keymaps = true,
      -- force oil to open files in the previous window, not its own
      default_file_explorer = true,
      restore_win_options = true,
      keymaps = {
        ["<C-v>"] = { "actions.select", opts = { vertical   = true } },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab        = true } },
      },
    })

    vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end
}
