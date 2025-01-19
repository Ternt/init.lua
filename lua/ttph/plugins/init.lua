return {
    "nvim-lua/plenary.nvim",

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        opts = {
            indent = { char = "│", highlight = "IblChar" },
            scope = { char = "│", highlight = "IblScopeChar" },
            indentLine_enabled = 1,
            filetype_exclude = {
                "help",
                "terminal",
                "lazy",
                "lspinfo",
                "TelescopePrompt",
                "TelescopeResults",
                "mason",
                "nvdash",
                "nvcheatsheet",
                "",
            },
            buftype_exclude = { "terminal" },
            show_trailing_blankline_indent = false,
            show_first_indent_level = false,
            show_current_context = true,
            show_current_context_start = true,
        },
        config = function(_, opts)
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            require("ibl").setup(opts)
        end,
    },

    -- formatting!
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = { lua = { "stylua" } },
        },
    },

    -- lsp stuff
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                cmd = { "Mason", "MasonUpdate", "MasonInstall" },
                opts = function()
                    return require "ttph.configs.mason"
                end
            },

            "williamboman/mason-lspconfig.nvim"
        },
        config = function()
            require("ttph.configs.lsp").defaults()
        end,
    },

    -- load luasnips + cmp related in insert mode only
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                -- snippet plugin
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                config = function(_, opts)
                    require("luasnip").config.set_config(opts)
                end,
            },

            -- autopairing of (){}[] etc
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)

                    -- setup cmp for autopairs
                    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },

            -- cmp sources plugins
            {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
            },
        },
        opts = function()
            return require "ttph.configs.acmp"
        end,
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        },
        cmd = "Telescope",
        opts = function()
            return require "ttph.configs.tele"
        end,
        config = function(_, opts)
            require('telescope').setup(opts)

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
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        opts = function()
            return require "ttph.configs.trsr"
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
