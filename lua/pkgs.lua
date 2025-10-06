local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  print("New Setup! Initializing …")

  local out = vim.fn.system({ 
    "git", 
    "clone", 
    "--filter=blob:none", 
    "--branch=stable", 
    "https://github.com/folke/lazy.nvim.git", 
    lazypath 
  })

  if vim.v.shell_error ~= 0 then
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {

  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    dependencies = 
    { 
      { 'nvim-lua/plenary.nvim' }, 
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }, 
    },
    config = function()
      require('cfg.telescope').setup()
    end
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('cfg.harpoon').setup()
    end
  },

  {
    'stevearc/oil.nvim',
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    lazy = false,
    config = function()
      require('cfg.oil').setup()
    end
  },
  
  {
    "rktjmp/lush.nvim",
    config = function()
      require('cfg.colors').setup()
    end
  }
}

require("lazy").setup({
  spec = plugin_specs,
  install = { missing = false },
  change_detection = { enabled = true, notify = false },
  rocks = { enabled = false },
  defaults = { lazy = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    backdrop = 100,
    border = "solid",
    title = "Lazy",
    pills = true,
    icons = {
      config = "󰒓 ",
      debug = "● ",
      event = " ",
      favorite = "  ",
      init = "󰒓 ",
      import = " 󰋺  ",
      keys = " 󰥻  ",
      lazy = "󰒲  ",
      runtime = "  ",
      require = "󰢱  ",
      source = " ",
      start = " ",
      list = { "■", "□", "●", "○", "◆", "◊" },
    },
  },
})

