local helpers = require("helpers")
local aucmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup
local get_opt = vim.api.nvim_get_option_value

aucmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    helpers.on_attach(client, args.buf)
  end,
})

aucmd('TextYankPost', {
  group = augrp('custom-highlight-yank', { clear = false }),
  callback = function()
    vim.highlight.on_yank()
  end
})

aucmd('TermOpen', {
  group = augrp('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
})

aucmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd([[
      hi GitSignsChangeInline gui=reverse
      hi GitSignsAddInline gui=reverse
      hi GitSignsDeleteInline gui=reverse
    ]])
  end,
})

-- header guards for new .h files
aucmd("BufNewFile", {
  group = augrp("new-h-file", { clear = true }),
  pattern = "*.h",
  callback = function()
    local filename  = vim.fn.expand("%:t:r")
    local guard     = filename:upper():gsub("[^A-Z0-9]", "_") .. "_H"
    local timestamp = os.date("// Created: %Y-%m-%d %H:%M:%S")
    local lines = {
      timestamp,
      "",
      "#ifndef " .. guard,
      "#define " .. guard,
      "",
      "",
      "",
      "#endif // " .. guard,
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, { 6, 0 })
  end,
  desc = "Insert timestamp and header guards on new .h files",
})

-- jump target indicator
do
  local ns = vim.api.nvim_create_namespace("jump_target")

  aucmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
    group = augrp("jump-target-indicator", { clear = true }),
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local row   = vim.api.nvim_win_get_cursor(0)[1]

      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

      local target = helpers.scope_jump(1, true)
      if not target or target == row then return end

      vim.api.nvim_buf_set_extmark(bufnr, ns, target - 1, 0, {
        virt_text     = { { " J", "Comment" } },
        virt_text_pos = "eol",
        priority      = 100,
      })
    end,
  })
end

-- show diagnostic virtual text only on cursor line
aucmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
  group = augrp("cursor-diagnostics", { clear = true }),
  callback = function()
    helpers.show_cursor_diagnostic()
  end,
})

---- Automatic text generation for specific files
local top_message = os.date("// %Y-%m-%d");

aucmd("BufNewFile", {
  group = augrp("copyright", { clear = true }),
  pattern = "*.c",
  callback = function()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { top_message, "" })
  end,
  desc = "Insert creation timestamp on new .h files",
})

aucmd("BufNewFile", {
  group = augrp("new-h-file", { clear = true }),
  pattern = "*.h",
  callback = function()
    local filename = vim.fn.expand("%:t:r")
    local guard = filename:upper():gsub("[^A-Z0-9]", "_") .. "_H"
    local lines = {
      top_message,
      "",
      "#ifndef " .. guard,
      "#define " .. guard,
      "",
      "",
      "",
      "#endif // " .. guard,
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, { 6, 0 })
  end,
  desc = "Insert timestamp and header guards on new .h files",
})
