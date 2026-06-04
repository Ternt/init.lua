return   {
  'nvim-telescope/telescope.nvim', 
  dependencies = { 
    { 'nvim-lua/plenary.nvim' }, 
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }, 
  },
  opts = {
    defaults = {
      sorting_strategy = "descending",
    },
    pickers = {
      find_files = {
        theme = 'ivy',
        path_display = { "filename_first" },
        previewer = false,
        prompt_title = "",
      },
      treesitter = {
        theme = 'ivy',
        path_display = { "shorten" },
        previewer = false,
        prompt_title = "",
        initial_mode = "normal",
      },
    },
  },
  config = function(_, opts)
    require('telescope').setup(opts)

    local map = vim.keymap.set

    map("n",  "<leader>th",  function()
      require('telescope.builtin').treesitter({ 
        symbols = { 'function' },
        symbol_width = 50,
      })
    end)

    map("n",  "<leader>tf",  "<cmd>Telescope find_files<cr>")
    map("n",  "<leader>ts",  "<cmd>Telescope grep_string<cr>")
    map("n",  "<leader>tg",  "<cmd>Telescope live_grep<cr>")
    map("n",  "<leader>tb",  "<cmd>Telescope buffers<cr>")
    map("n",  "<C-v>",       "<cmd>Telescope select_vertical<cr>")
  end
}
