require("ttph.opts")
require("ttph.maps")
require("ttph.lazy")


local augroup = vim.api.nvim_create_augroup
local ttph_group = augroup('ttph', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('highlight-yank', { clear = true })

autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = yank_group,
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 50,
        })
    end,
})

autocmd('BufEnter', {
    group = ttph_group,
    callback = function()
        -- if vim.bo.filetype == "zig" then
        --     vim.cmd.colorscheme("tokyonight-night")
        vim.cmd.colorscheme("jellybeans")
    end
})

autocmd('LspAttach', {
    group = ttph_group,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

local is_win32 = vim.fn.has("win32")
if (is_win32 == 1) then
    local powershell_options = {
        shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
        shellcmdflag = "-NoExit -Command \"&{ $vsPath=&(Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath \'\\Microsoft Visual Studio\\Installer\\vswhere.exe\') -property installationpath; Import-Module (Get-ChildItem $vsPath -Recurse -File -Filter Microsoft.VisualStudio.DevShell.dll).FullName; Enter-VsDevShell d36e7ee5 -SkipAutomaticLocation -DevCmdArguments \'\"-arch=x64 -host_arch=x64\"\'}\"",
        shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
        shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
        shellquote = "",
        shellxquote = "",
    }

    for option, value in pairs(powershell_options) do
        vim.opt[option] = value
    end
end
