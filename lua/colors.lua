local M = {}

M.colorscheme_conf = {
    -- zenbones
    zenbones = function()
        vim.cmd([[colorscheme zenwritten]])
    end,
    raddbg = function()
        require('schemes.raddbg')
    end,
    -- oxocarbon
    oxocarbon = function()
        vim.opt.background = 'dark'
        vim.cmd([[colorscheme oxocarbon]])
    end
}

M.paint = function(scheme)
    if not scheme or scheme == "" then
        vim.cmd([[colorscheme default]])
    end

    M.colorscheme_conf[scheme]()
end

return M
