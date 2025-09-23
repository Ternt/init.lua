local M = {}

-- setup options
M.opts =  {
    whitespace = {
        highlight = { 'Function', 'Label' },
        remove_blankline_trail = true,
    },
    scope = {
        enabled = true,
        show_start = true,
    }
}

-- configuration function
M.setup = function()
    require('ibl').setup(M.opts)
end

return M
