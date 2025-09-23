local M = {}

-- setup options
M.opts = {
    enabled = true,
    scope = 'line',
    text_align = 'left',
    placement = 'top',
    toggle_event = { 'InsertEnter', 'InsertLeave' },
    update_event = { 'DiagnosticChanged', 'BufReadPost' },
    render_event = { 'DiagnosticChanged', 'CursorMoved' },
}

-- configuration function
M.setup = function()
    require('diagflow').setup(M.opts)
end

return M
