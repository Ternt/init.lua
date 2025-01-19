function ColorMyPencils(color)
	color = color or "moonfly"
	vim.cmd.colorscheme(color)
end

return {
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
        "wtfox/jellybeans.nvim",
        name = "jellybeans",
        config = function()
            require("jellybeans").setup({
                style = "dark",
                transparent = true,
                italics = false,
            })
        end,
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
}
