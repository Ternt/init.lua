local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  print("New Setup! Initializing …")

  local out = vim.fn.system({ 
    "git", 
    "clone", 
    "--filter=blob:none", 
    "--branch=stable", 
    "https://github.com/folke/lazy.nvim.git", 
    lazypath 
  })

  if vim.v.shell_error ~= 0 then
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 
    'stevearc/oil.nvim',
    branch = 'master',
    lazy = false,
    dependencies = {'nvim-mini/mini.icons'},
    config = function()
      require('oil').setup{
        use_default_keymaps = true,
        default_file_explorer = true,
        restore_win_options = true,
        keymaps = {
          ["<C-v>"] = { "actions.select", opts = { vertical   = true } },
          ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab        = true } },
        },
      }
      vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end
  },

  { 
    'gbprod/substitute.nvim',
    config = function()
      require('substitute').setup{
        highlight_substituted_text = {
          timer = 100,
        },
        range = {
          group_substituted_text = false,
          prefix = "s",
          prompt_current_text = false,
          suffix = "",
        },
      }
      vim.keymap.set("n", "r", require("substitute").operator, {})
      vim.keymap.set("n", "rr", require("substitute").line, {})
      vim.keymap.set("n", "R", require("substitute").eol, {})
      vim.keymap.set("x", "r", require("substitute").visual, {})
      vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
      vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    build = ":TSUpdate",
    config = function(_, opts)
      require('nvim-treesitter').install{ 'c', 'cpp' }
      require('nvim-treesitter').setup{
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = false },
      }
    end,
  },


  {
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
          theme = 'dropdown',
          path_display = { "filename_first" },
          previewer = false,
          prompt_title = "",
        },
        treesitter = {
          theme = 'dropdown',
          path_display = { "shorten" },
          previewer = false,
          prompt_title = "",
          initial_mode = "normal",
        },
        live_grep = {
          theme = 'dropdown',
          path_display = { "shorten" },
          layout_config={ width=100 },
          previewer = true,
          prompt_title = "",
          initial_mode = "insert",
        },
        buffers = {
          theme = 'dropdown',
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

      map("n",  "<leader>ff",  "<cmd>Telescope find_files<cr>")
      map("n",  "<leader>fs",  "<cmd>Telescope grep_string<cr>")
      map("n",  "<leader>fg",  "<cmd>Telescope live_grep<cr>")
      map("n",  "<C-v>",       "<cmd>Telescope select_vertical<cr>")
      vim.keymap.set('n', '<leader>fb', function()
        require('telescope.builtin').buffers({ show_all_buffers = true })
      end, { desc = 'Find buffers (incl. terminal)' })
    end
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')

      harpoon:setup({})

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("", "<leader>4", function() harpoon:list():select(4) end)
      vim.keymap.set("", "<leader>5", function() harpoon:list():select(5) end)
      vim.keymap.set("", "<leader>6", function() harpoon:list():select(6) end)
      vim.keymap.set("", "<leader>7", function() harpoon:list():select(7) end)

      -- toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-P>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end)

      -- harpoon extensions
      local harpoon_extensions = require("harpoon.extensions")

      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })

      harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    end
  },

  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        open_mapping = nil,
        direction = 'horizontal',
        size = 10,
      })

      local Terminal = require('toggleterm.terminal').Terminal
      local term = Terminal:new({
        hidden = true,
        close_on_exit = false,
      })

      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

      -- Toggle on terminal
      vim.keymap.set('n', '<leader>k', function()
        term:toggle()
      end, { desc = 'Toggle persistent terminal' })

      -- Toggle terminal off from within terminal mode
      vim.keymap.set('t', '<leader>k', function()
        term:toggle()
      end, { desc = 'Toggle terminal off' })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '▎' },
          change       = { text = '▎' },
          delete       = { text = '▎' },
          topdelete    = { text = '▎' },
          changedelete = { text = '▎' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navigation between hunks
          vim.keymap.set('n', ']h', gs.next_hunk, { buffer = bufnr, desc = 'Git: next hunk' })
          vim.keymap.set('n', '[h', gs.prev_hunk, { buffer = bufnr, desc = 'Git: prev hunk' })

          -- View diff
          vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = bufnr, desc = 'Git: diff file' })
          vim.keymap.set('n', '<leader>gD', function() gs.diffthis('~') end, { buffer = bufnr, desc = 'Git: diff against last commit' })

          -- Preview hunk in floating window
          vim.keymap.set('n', '<leader>gh', gs.preview_hunk, { buffer = bufnr, desc = 'Git: preview hunk' })

          -- Stage/reset individual hunks
          vim.keymap.set('n', '<leader>ghs', gs.stage_hunk, { buffer = bufnr, desc = 'Git: stage hunk' })
          vim.keymap.set('n', '<leader>ghr', gs.reset_hunk, { buffer = bufnr, desc = 'Git: reset hunk' })

          -- Toggle blame line
          vim.keymap.set('n', '<leader>gtb', gs.toggle_current_line_blame, { buffer = bufnr, desc = 'Git: toggle blame line' })
        end
      })
    end,
  },
})
