return {
  "mcauley-penney/techbase.nvim",
  branch = "main",
  priority = 1000,
  opts = {
    hl_overrides = {
      Normal                        = { fg = "#e5e5e5", bg = "#1b1b1b" },

      Comment                       = { fg = "#717171" },
      Keyword                       = { fg = "#cbcbcb" },
      Function                      = { fg = "#cbcbcb" },
      Constant                      = { fg = "#cbcbcb" },
      Operator                      = { fg = "#ababab" },
      String                        = { fg = "#98abb1" },
      Number                        = { fg = "#98abb1" },
      Type                          = { fg = "#cbcbcb" },

      ["@string"]                   = { fg = "#98abb1" },
      ["@string.escape"]            = { fg = "#8aff00" },

      ["@character"]                = { fg = "#98abb1" },
      ["@character.escape"]         = { fg = "#8aff00" },

      ["@boolean"]                  = { fg = "#98bc80" },
      ["@number"]                   = { fg = "#98abb1" },
      ["@number.float"]             = { fg = "#98abb1" },

      ["@constant"]                 = { fg = "#cbcbcb" },
      ["@constant.macro"]           = { fg = "#d96759" },
      ["@constant.builtin"]         = { fg = "#d96759" },

      ["@keyword.import"]           = { fg = "#d96759" },
      ["@keyword.modifier"]         = { fg = "#ababab" },
      ["@keyword.type"]             = { fg = "#fec746" },
      ["@keyword.directive"]        = { fg = "#d96759" },
      ["@keyword.directive.define"] = { fg = "#d96759" },

      ["@type"]                     = { fg = "#cbcbcb" },
      ["@type.builtin"]             = { fg = "#cbcbcb" },
      ["@type.definition"]          = { fg = "#cbcbcb" },
      ["@function.macro"]           = { fg = "#d96759" },
    },
  },
  init = function() vim.cmd.colorscheme("techbase") end,
}

