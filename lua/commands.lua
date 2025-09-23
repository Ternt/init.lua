local main_filedir = require('utils').getenvs('USERPROFILE')

-- creates a temp note file
vim.api.nvim_create_user_command('Scratch', function(opts)
    local filename = string.upper(opts.fargs[1])

    local file = vim.fs.joinpath(main_filedir, filename)
    vim.api.nvim_cmd({ cmd = "e", args = {file}})
end, { nargs = 1 })


-- Creating templates -------------------------------------------
local templates = {
    path = vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath('data'), 'tmpl')),
}

local c_augroup = vim.api.nvim_create_augroup('c_proj.config', { clear=false })

vim.api.nvim_create_autocmd({'BufNewFile'}, {
    group = "c_proj.config",
    pattern = {'*.h'}, 
    callback = function(ev)
        local template = vim.fs.joinpath(templates.path, 'tmpl.h') 
        local filepath = vim.fn.expand("<afile>")
        local filename = vim.fs.basename(filepath)

        local cmd = string.gsub("0read $VAR", "$VAR", template) 
        vim.api.nvim_command(cmd)

        local t = {}
        t['filename'] = filename
        t['title'] = string.gsub(string.upper(filename), '%.', '_')
        for k,v in pairs(t) do
            cmd = string.format('%%s/<<%s>>/%s/g', k, v) 
            vim.api.nvim_command(cmd)
        end
    end
})
