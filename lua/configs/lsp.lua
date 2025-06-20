local M = {}

-- setup options
M.opts =  {}

-- configuration function
M.setup = function()
  require('lspconfig').clangd.setup({
    cmd = {'clangd', '--background-index', '--compile-commands-dir="./"', '--clang-tidy'}
  })
end

return M
