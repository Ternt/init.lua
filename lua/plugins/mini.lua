return {
  { 
    'nvim-mini/mini.indentscope', 
    version = '*',
    config = function()
      require('mini.indentscope').setup({
        draw = {
          delay = 0,
          animation = require('mini.indentscope').gen_animation.none()
        },
        options = {
          try_as_border = true,
          indent_at_cursor = false,
        },
        mappings = {
          goto_top = '',
          goto_bottom = '',
        },
        symbol = '╎'
      })

      vim.cmd.highlight('MiniIndentscopeSymbol guifg=#515151')
      vim.cmd.highlight('MiniIndentscopeSymbolOff guifg=#414141')
    end,
  },
}
