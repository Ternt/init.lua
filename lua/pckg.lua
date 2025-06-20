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
        config = function()
            require('configs.lsp').setup()
        end
    },

    -- autocompletion
    {
        'saghen/blink.cmp', version = '1.*',
        config = function()
            require('configs.cmp').setup()
        end
    },

    {
        'stevearc/oil.nvim',
        lazy = false,
        config = function()
            require('configs.oil').setup()
        end
    },
    
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
    change_detection = { notify = false },
    pkg = { sources = { "lazy", "packspec" } },
})


