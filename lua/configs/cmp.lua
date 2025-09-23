local M = {}

-- setup options
M.opts = {
    completion = {
        ghost_text = { 
            enabled = false, 
            show_with_menu = false 
        },
        menu = { auto_show = true },
    },
    signature = { 
        enabled = true, 
        window = { show_documentation = false, },
    },
}

-- configuration function
M.setup = function()
    require('blink.cmp').setup(M.opts)
end

return M
