local M = {}

-- setup options
M.opts = {}

-- configuration function
M.setup = function()
  vim.opt.runtimepath:append(vim.fn.stdpath('data') .. "/parsers")

  local ts = require('nvim-treesitter.configs').setup({
    ensure_installed = {
      "vimdoc", "javascript", "typescript", "c", "rust", "jsdoc", 
    },
    sync_install = false,
    auto_install = true,
    indent = { enable = true },
    parser_install_dir = vim.fn.stdpath('data') .. "/parsers",
    highlight = {

      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },

  })

end

return M
