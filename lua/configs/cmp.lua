local M = {}

-- setup options
M.opts =  {}

-- configuration function
M.setup = function()
  require('blink.cmp').setup(M.opts)
end

return M
