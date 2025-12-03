local aucmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup
local get_opt = vim.api.nvim_get_option_value
local aucmd_fn = require("aucmd.functions")

---- Upon entering a buffer
enter_grp = augrp("Entering", { clear = true })

aucmd('BufEnter', {
  group = enter_grp,
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    local root = tools.get_path_root(path)

    if root ~= nil then
      vim.cmd(":lcd " .. root)
    end
  end,
  desc = "Set root dir and initialize version control branch",
})

aucmd("BufEnter", {
  group = grp,
  callback = function()
    vim.api.nvim_set_option_value("formatoptions", "2cjnpqrt", {})

    vim.opt.formatlistpat:append([[\|^\s*\w\+[\]:.)}\t ]\s\+]]) -- Lettered lists
    vim.opt.formatlistpat:append([[\|^\s*>\s]]) -- Markdown blockquotes

    -- Dynamically append commentstring-based pattern
    local commentstring = vim.bo.commentstring:match("^(.*)%%s$")
    if commentstring then
      vim.opt.formatlistpat:append([[\|^\s*]] .. commentstring .. [[\s*]])
    end

    local ft = get_opt("filetype", {})
    aucmd_fn.set_indent(ft)
    -- aucmd_fn.set_textwidth(ft)
  end,
  desc = "Set options for formatting",
})

aucmd("BufWinEnter", {
  group = grp,
  command = "silent! loadview",
  desc = "Restore view settings",
})

aucmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    aucmd_fn.on_attach(client, args.buf)
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


---- During editing
edit_grp = augrp("Editing", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorHoldI" }, {
  group = edit_grp,
  callback = function()
    local win_h = vim.api.nvim_win_get_height(0)
    local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
    local dist = vim.fn.line("$") - vim.fn.line(".")
    local rem = vim.fn.line("w$") - vim.fn.line("w0") + 1

    if dist < off and win_h - rem + dist < off then
      local view = vim.fn.winsaveview()
      view.topline = view.topline + off - (win_h - rem + dist)
      vim.fn.winrestview(view)
    end
  end,
  desc = "When at eob, bring the current line towards center screen",
})

vim.api.nvim_create_autocmd("VimResized", {
  group = grp,
  command = [[tabdo wincmd =]],
})


---- Upon leaving a buffer
leave_grp = augrp("Leaving", { clear = true })

aucmd("BufWinLeave", {
  group = leave_grp,
  command = "silent! mkview",
  desc = "Create view settings",
})

