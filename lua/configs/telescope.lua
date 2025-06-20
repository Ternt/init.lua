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
  require('configs.telescope.multigrep').setup()

  local map = vim.keymap.set

  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
  map("n", "<leader>fa", "<cmd>Telescope find_files hidden=true follow=true no_ignore=true<CR>")
  -- map("n", "<leader>fg", function()
  --   local opts = require('telescope.themes').get_ivy({ previewer = false })
  --   require('telescope.builtin').live_grep(opts)
  -- end)
  map("n", "<leader>fs", "<cmd>Telescope grep_string<cr>")
  map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

  map("n", "<leader>cp", function()
    require('telescope.builtin').find_files({
      cwd = vim.fn.stdpath('config')
    })
  end)

  map("n", "<leader>ep", function()
    require('telescope.builtin').find_files({
      cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
    })
  end)
end

return M
