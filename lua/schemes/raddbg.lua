local colors_name = "raddbg"
vim.g.colors_name = colors_name

local util = require("zenbones.util")
local lush = require("lush")
local hsluv  = lush.hsluv 

local bg = vim.o.background

local palette
if bg == "dark" then
    palette = util.palette_extend({
        bg          = hsluv("#1c1c1c"),
        fg          = hsluv("#e5e5e5"),
        rose        = hsluv("#fb4934"),
        green       = hsluv("#2eab14"),
        yellow      = hsluv("#fec746"),
        water       = hsluv("#83a598"),
        ice         = hsluv("#98abb1"),
        blossom     = hsluv("#d3869b"),
        wood        = hsluv("#b38d4c"),
    }, bg)
end

-- Generate the lush specs using the generator util
local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({base_specs}).with(function(injected_function)
    local sym = injected_function.sym
    return {
        Function    { fg = palette.fg.darken(20),       gui = 'default' },
        Special     { fg = palette.fg.darken(20),       gui = 'default' },
        Comment     { fg = palette.bg.lighten(25),      gui = 'default' },
        Type        { fg = palette.yellow,              gui = 'default' },
        Statement   { fg = palette.wood,                gui = 'default' },
        Boolean     { fg = palette.wood,                gui = 'default' },
        String      { fg = palette.ice,                 gui = 'default' },
        Number      { fg = palette.ice,                 gui = 'default' },
        Todo        { fg = palette.green.darken(30),    gui = 'default' },
        PreProc     { fg = palette.rose,                gui = 'default' },

        IblIndent   { fg = palette.bg.lighten(10),      gui = 'default' },
        IndentLine  { fg = palette.bg.lighten(10),      gui = 'default' },
        IblScope    { fg = palette.bg.lighten(10),      gui = 'default' },

        DiagnosticOk                { fg = palette.green,   gui = 'default'   },
        DiagnosticSignOk            { fg = palette.green,   gui = 'default'   },
        DiagnosticUnderlineOk       { fg = palette.fg,      gui = 'underline' },
        DiagnosticVirtualTextOk     { fg = palette.fg,      gui = 'default'   },
        DiagnosticHint              { fg = palette.rose,    gui = 'default'   },
        DiagnosticSignHint          { fg = palette.rose,    gui = 'default'   },
        DiagnosticUnderlineHint     { fg = palette.fg,      gui = 'underline' },
        DiagnosticVirtualTextHint   { fg = palette.fg,      gui = 'default'   },
        DiagnosticInfo              { fg = palette.rose,    gui = 'default'   },
        DiagnosticSignInfo          { fg = palette.rose,    gui = 'default'   },
        DiagnosticUnderlineInfo     { fg = palette.fg,      gui = 'underline' },
        DiagnosticVirtualTextInfo   { fg = palette.fg,      gui = 'default'   },
        DiagnosticWarn              { fg = palette.rose,    gui = 'default'   },
        DiagnosticSignWarn          { fg = palette.rose,    gui = 'default'   },
        DiagnosticUnderlineWarn     { fg = palette.fg,      gui = 'underline' },
        DiagnosticVirtualTextWarn   { fg = palette.fg,      gui = 'default'   },
        DiagnosticError             { fg = palette.rose,    gui = 'default'   },
        DiagnosticSignError         { fg = palette.rose,    gui = 'default'   },
        DiagnosticUnderlineError    { fg = palette.fg,      gui = 'underline' },
        DiagnosticVirtualTextError  { fg = palette.fg,      gui = 'default'   },
    }
end
)

lush(specs)
require("zenbones.term").apply_colors(palette)
