local M = {}

-- setup options
M.opts =  {
  pickers = {
    find_files = {
      theme = 'ivy',
      shorten_path = false,
      previewer = false,
    },
  },
  extensions = {
    fzf = {}
  }
}

-- configuration function
M.setup = function()
  require('telescope').setup(M.opts)
  require('telescope').load_extension('fzf')

  local map = vim.keymap.set

  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
  map("n", "<leader>fa", "<cmd>Telescope find_files hidden=true follow=true no_ignore=true<CR>")
  map("n", "<leader>fs", "<cmd>Telescope grep_string<cr>")
  map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
  map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")
  map("i", "<C-v>", "<cmd>Telescope select_vertical<cr>")
  map("n", "<C-h>", "<cmd>Telescope select_horizontal<cr>")

  map("n", "<leader>fg", function()
    local opts = require('telescope.themes').get_ivy({ previewer = false })
    require('configs.telescope_multigrep').setup(opts)
  end)

  map("n", "<leader>fnf", function()
      cwd = "C:/Users/kylep/Notes/"
  end)

  map("n", "<leader>fcf", function()
    require('telescope.builtin').find_files({
      cwd = vim.fn.stdpath('config')
    })
  end)

  map("n", "<leader>fdf", function()
    require('telescope.builtin').find_files({
      cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
    })
  end)
end

return M
