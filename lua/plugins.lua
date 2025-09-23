local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable", -- latest stable release
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "ERROR: Failed to clone lazy.nvim\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
    -- which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
    },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = "false",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        config = function()
            require('configs.treesitter').setup()
        end,
    },

    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }, },
        config = function()
            require('configs.telescope').setup()
        end
    },

    -- lsp
    {
        'neovim/nvim-lspconfig',
        dependencies = { { 'saghen/blink.cmp', version = '1.*' }, },
        config = function()
            -- autocompletion
            require('configs.cmp').setup()
            require('configs.lsp').setup()
        end
    },

    -- autocompletes
    -- {
    --     'm4xshen/autoclose.nvim',
    --     config = function()
    --         require('autoclose').setup({
    --         })
    --     end
    -- },

    -- oil
    {
        'stevearc/oil.nvim',
        lazy = false,
        config = function()
            require('configs.oil').setup()
        end
    },

    -- diagnostics
    {
        'dgagn/diagflow.nvim',
        event = 'LspAttach',
        config = function()
            require('configs.diagnostics').setup()
        end
    },

    -- indententation
    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     main = "ibl",
    --     config = function()
    --         require('configs.ibl').setup()
    --     end
    -- },

    -- colorschemes 
    { 'nyoom-engineering/oxocarbon.nvim', priority = 1000, },

    { 'zenbones-theme/zenbones.nvim',
      dependencies = 'rktjmp/lush.nvim',
      lazy = false,
      priority = 1000,
    },
}

require("lazy").setup({
    spec = plugin_specs,
    change_detection = { 
        enabled = false,
        notify = false,
    },
    pkg = { sources = { "lazy", "packspec" } },
})


