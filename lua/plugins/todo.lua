return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    keywords = {
      TODO  = { color = "info"  },
      NOTE  = { color = "info"  },
      ERROR = { color = "error" },
    },
    highlight = {
      keyword = "fg",
      after = "empty",
    },
    colors = {
      info  = { "#0EA026" },
      error = { "#BA1F1F" },
    },
  }
}
