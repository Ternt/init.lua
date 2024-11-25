return {
    'nvim-telescope/telescope.nvim',

    tag = "0.1.5",

    dependencies = {
        { 'nvim-lua/plenary.nvim' },
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>fs', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>fn', function() 
            builtin.find_files({ 
                cwd = vim.fn.stdpath 'config', 
                layout_strategy = 'horizontal',	 
            })
        end)
    end
}
