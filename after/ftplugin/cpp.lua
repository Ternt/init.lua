buf = vim.fs.normalize(vim.fn.expand("%"))
cwd = vim.loop.cwd()

-- Helper functions -----------------------------------------
local get_project_path = function()
  local project_path = string.gsub(cwd, buf, "")
  return project_path
end


-- C setup ----------------------------------------------

local C = {}

C.setup = function()
  local project_path = get_project_path() 

  C.opts = {
    exe_name = 'main.exe',
    build_folder_path = vim.fs.joinpath(project_path, 'build'),
    build_script_path = vim.fs.joinpath(project_path, 'build.bat')
  }
end

C.setup()


-- Commands ---------------------------------------------

vim.api.nvim_create_user_command('CBuildBatch', 
  function()
    local opts = C.opts
    local build_script_path = "\"" .. opts.build_script_path .. "\""
    vim.api.nvim_cmd({ cmd = "!", args = {build_script_path}}, {})
  end, { nargs = 0 })

vim.api.nvim_create_user_command('CRunExe', 
  function()
    local opts = C.opts
    local exe_path = "\"" .. vim.fs.joinpath(opts.build_folder_path, opts.exe_name) .. "\""
    vim.api.nvim_cmd({ cmd = "!", args = {exe_path}}, {})
  end, { nargs = 0 })

vim.api.nvim_create_user_command('CDebug', 
  function()
    local opts = C.opts
    local exe_path = "\"" .. vim.fs.joinpath(opts.build_folder_path, opts.exe_name) .. "\""
    vim.api.nvim_cmd({ cmd = "!", args = {"raddbg", exe_path}}, {})
  end, { nargs = 0 })

-- Mappings ---------------------------------------------

local map = vim.keymap.set

map('n', '<F5>',  '<cmd>CBuildBatch<CR>', { noremap = true })
map('n', '<F9>',  '<cmd>CRunExe<CR>',     { noremap = true })
map('n', '<F11>', '<cmd>CDebug<CR>',      { noremap = true })

