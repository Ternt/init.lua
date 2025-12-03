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

require("lazy").setup("plugins", {
  install = { missing = false },
  change_detection = { enabled = true, notify = false },
  rocks = { enabled = false },
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
  defaults = { lazy = false },
  ui = {
    backdrop = 100,
    border = "solid",
    title = "Lazy",
    pills = true,
    icons = {
      cmd = tools.ui.kind_icons.Terminal,
      config = "󰒓 ",
      debug = "● ",
      event = " ",
      favorite = "  ",
      ft = tools.ui.kind_icons.File,
      init = "󰒓 ",
      import = " 󰋺  ",
      keys = " 󰥻  ",
      lazy = "󰒲  ",
      loaded = tools.ui.icons.bullet,
      not_loaded = tools.ui.icons.open_bullet,
      plugin = tools.ui.kind_icons.Module,
      runtime = "  ",
      require = "󰢱  ",
      source = " ",
      start = " ",
      task = tools.ui.icons.ok,
      list = { "■", "□", "●", "○", "◆", "◊" },
    },
  },
})

