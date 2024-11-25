function ColorMyPencils(color)
	color = color or "moonfly"
	vim.cmd.colorscheme(color)
end

return {
    -- -- indentscope visualization
    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     main = "ibl",
    --     config = function()
    --         require("ibl").setup({
    --             indent = {
    --                 char = '▏',
    --                 smart_indent_cap = true,
    --             },
    --             whitespace = {
    --                 remove_blankline_trail = true,
    --             },
    --             scope = {
    --                 enabled = true,
    --                 show_exact_scope = true
    --             },
    --         })
    --     end
    -- },

    {
        "bluz71/vim-moonfly-colors",
        name="moonfly",
        lazy=false,
        priority=1000,
        config=function()
            vim.g.moonflyCursorColor = true
            vim.g.moonflyTerminalColors = true
            vim.g.moonflyWinSeparator = 2
            vim.g.moonflyItalics = false
            vim.g.moonflyTransparent = true
            vim.g.moonflyUndercurls = true
            vim.g.moonflyVirtualTextColor = true

            ColorMyPencils()
        end
    },

    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = true,
            })
        end,
    },

    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
            })
        end
    },
}
