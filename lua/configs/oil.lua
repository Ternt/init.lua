-- helper functions
function _G.oil_get_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

local M = {}

-- setup options
M.opts =  {
  columns = { 'icon' },
  win_options = {
    wrap = true,
    winbar = "%!v:lua.oil_get_winbar()",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
}

-- configuration function
M.setup = function()
  require('oil').setup(opts)
end

return M
