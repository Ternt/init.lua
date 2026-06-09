local aucmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup
local get_opt = vim.api.nvim_get_option_value

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

