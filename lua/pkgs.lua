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
    "echasnovski/mini.icons",
    version = false,
    config = function()
      local mini = require("mini.icons")

      local make_icon_tbl = function(category)
        local res = {}
        local postfix = "  "

        -- get list of keys, access keys, modify them, then store and return
        -- output format: key = { glyph = "" }
        for _, name in ipairs(mini.list(category)) do
          res[name] = { glyph = " " .. mini.get(category, name) .. postfix }
        end

        return res
      end

      local default_icon = { glyph = "   " }

      local defaults = make_icon_tbl("default")
      defaults["extension"] = default_icon
      defaults["file"] = default_icon
      defaults["filetype"] = default_icon

      local file_icons = make_icon_tbl("file")
      file_icons[".zshrc"] = { glyph = " 󰒓  " }
      file_icons["init.lua"] = { glyph = " 󰢱  ", hl = "MiniIconsAzure" }
      file_icons["README.md"] = { glyph = "   ", hl = "MiniIconsCyan" }
      file_icons["lazy"] = default_icon

      local ft_icons = make_icon_tbl("filetype")
      ft_icons["dosini"] = default_icon
      ft_icons["text"] = default_icon

      mini.setup({
        default = defaults,
        directory = make_icon_tbl("directory"),
        extension = make_icon_tbl("extension"),
        -- https://github.com/echasnovski/mini.nvim/issues/1384
        file = file_icons,
        filetype = ft_icons,
        lsp = make_icon_tbl("lsp"),
      })
    end,
  },

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
    config = function()
      require('nvim-treesitter').install{ 'c', 'cpp', 'lua' }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "lua" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require('nvim-treesitter-textobjects').setup{
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]c"] = "@class.outer",
            ["]f"] = "@function.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]["] = "@class.outer",
            ["]F"] = "@function.outer",
          },
          goto_previous_start = {
            ["[c"] = "@class.outer",
            ["[f"] = "@function.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["]F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
        select = {
          enable = true,
          keymaps = {
            ["iC"] = "@call.inner",
            ["aC"] = "@call.outer",
            ["ic"] = "@conditional.inner",
            ["ac"] = "@conditional.outer",
            ["if"] = "@function.inner",
            ["af"] = "@function.outer",
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
          },
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
    end
  },

  {
    "mason-org/mason.nvim",
    opts = {
      max_concurrent_installers = 20,
      ui = {
        height = 0.8,
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      handlers = {
        function(name) vim.lsp.enable(name) end,
      },
    },
  },

  {
    "folke/lazydev.nvim",
    dependencies = "neovim/nvim-lspconfig",
    ft = "lua",
    opts = true,
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        suppress_on_insert = true,
        display = {
          done_ttl = 2,
          progress_icon = {
            pattern = {
              " 󰫃 ",
              " 󰫄 ",
              " 󰫅 ",
              " 󰫆 ",
              " 󰫇 ",
              " 󰫈 ",
            },
          },
          done_style = "Comment",
          group_style = "Comment",
          icon_style = "Comment",
          progress_style = "Comment",
        },
      },
      notification = {
        window = {
          border_hl = "Comment",
          normal_hl = "Comment",
          winblend = 100,
          border = "solid",
          relative = "win",
        },
      },
    },
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = {
      text_format = function(symbol)
        local res = {}

        if symbol.references then
          local usage = symbol.references == 1 and "reference" or "references"
          table.insert(
            res,
            { ("󰌹  %s %s"):format(symbol.references, usage), "LspCodeLens" }
          )
        end

        return res
      end,
    },
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    init = function()
      local map = vim.keymap.set
      local modes = { "o", "x" }
      -- indentation
      map(modes, "ii", function() require("various-textobjs").indentation(true, true) end)
      map(modes, "ai", function() require("various-textobjs").indentation(false, true) end)

      -- values, e.g. variable assignment
      map(modes, "iv", function() require("various-textobjs").value(true) end)
      map(modes, "av", function() require("various-textobjs").value(false) end)
    end
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
        diagnostics = {
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
      local gs = require("gitsigns")
      gs.setup{
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "│" },
        },
        word_diff = false,
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "previous hunk" })

          -- Actions
          map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line { full = true }
          end, { desc = "blame hunk" })
        end,
      }
    end,
  },

  {
    "mcauley-penney/techbase.nvim",
    branch = "main",
    priority = 1000,
    opts = {
      hl_overrides = {
        Normal                        = { fg = "#e5e5e5", bg = "#1b1b1b" },

        Comment                       = { fg = "#717171" },
        Keyword                       = { fg = "#cbcbcb" },
        Function                      = { fg = "#cbcbcb" },
        Constant                      = { fg = "#cbcbcb" },
        Operator                      = { fg = "#ababab" },
        String                        = { fg = "#98abb1" },
        Number                        = { fg = "#98abb1" },
        Type                          = { fg = "#ceaf64" },

        ["@string"]                   = { fg = "#98abb1" },
        ["@string.escape"]            = { fg = "#8aff00" },

        ["@character"]                = { fg = "#98abb1" },
        ["@character.escape"]         = { fg = "#8aff00" },

        ["@boolean"]                  = { fg = "#98bc80" },
        ["@number"]                   = { fg = "#98abb1" },
        ["@number.float"]             = { fg = "#98abb1" },

        ["@constant"]                 = { fg = "#cbcbcb" },
        ["@constant.macro"]           = { fg = "#d96759" },
        ["@constant.builtin"]         = { fg = "#d96759" },

        ["@keyword.import"]           = { fg = "#d96759" },
        ["@keyword.modifier"]         = { fg = "#ababab" },
        ["@keyword.type"]             = { fg = "#fec746" },
        ["@keyword.directive"]        = { fg = "#d96759" },
        ["@keyword.directive.define"] = { fg = "#d96759" },

        ["@type"]                     = { fg = "#cbcbcb" },
        ["@lsp.type.type"]            = { fg = "#cbcbcb" },
        ["@lsp.type.typedef"]         = { fg = "#ceaf64" },
        ["@lsp.type.typeParameter"]   = { fg = "#cbcbcb" },
        ["@type.builtin"]             = { fg = "#cbcbcb" },
        ["@type.definition"]          = { fg = "#cbcbcb" },
        ["@function.macro"]           = { fg = "#d96759" },
      },
    },
    init = function() vim.cmd.colorscheme("techbase") end,
  }
})
