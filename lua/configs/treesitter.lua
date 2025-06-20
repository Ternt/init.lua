local M = {}

-- setup options
M.opts =  {
    ensure_installed = { "lua", "c", "json", "toml", "python" },
    sync_install = false,
    auto_install = false,
    indent = { enable = true },
    highlight = { enable = true },
}

-- configuration function
M.setup = function()
  require("nvim-treesitter.install").prefer_git = true
  require("nvim-treesitter").setup(M.opts)

  vim.opt.runtimepath:append('C:/Users/kylep/AppData/Local/nvim-data/site')
end

return M
