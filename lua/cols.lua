local M = {}

M.setup = function()
  local c = {
    -- foreground
    normal_fg = "#D8DFED",


    -- background
    normal_bg = "#1C2026",

    -- accent
    cursor = "#DD403B",
  }

  local hl = {}
  hl["Normal"] = { fg = c.normal_fg, bg = c.normal_bg }

  for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

return M
