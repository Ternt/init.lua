return {
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
}

