local M = {}

-- setup options
M.opts =  {}

-- configuration function
M.setup = function()
    -- vim.lsp.enable('clangd')
    -- vim.lsp.config('clangd', {
    --     cmd = {'clangd', '--background-index', '--compile-commands-dir="./"', '--clang-tidy'}
    -- })

    vim.lsp.enable('ts_ls')
    vim.lsp.config('ts_ls', {})

    vim.lsp.enable('zls')
    vim.lsp.config('zls', {})
end

return M
