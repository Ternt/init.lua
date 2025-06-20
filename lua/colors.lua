local M = {}

M.colorscheme_conf = {
    zenbones = function()
        vim.g.zenwritten_darkness = 'stark'
        vim.g.zenwritten_solid_line_nr = true
        vim.g.zenwritten_solid_vert_split = true
        vim.g.zenwritten_float_border = true
        vim.g.zenwritten_italic_comments = false
        vim.g.zenwritten_italic_strings = false
        vim.g.zenwritten_colorize_diagnoistic_underline_text = true

        vim.cmd([[colorscheme zenwritten]])
    end,
    oxocarbon = function()
        vim.opt.background = 'dark'
        vim.cmd([[colorscheme oxocarbon]])
    end
}

M.paint = function(scheme)
    if not scheme or scheme == "" then
        return nil;
    end

    M.colorscheme_conf[scheme]()
end

return M
