local aucmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup
local get_opt = vim.api.nvim_get_option_value
local aucmd_fn = require("aucmd.functions")

---- Upon entering a buffer
enter_grp = augrp("Entering", { clear = true })

aucmd('BufEnter', {
  group = enter_grp,
  callback = function()
    if vim.bo.filetype == "oil" then return end

    local path = vim.api.nvim_buf_get_name(0)
    local root = tools.get_path_root(path)

    if root ~= nil then
      vim.cmd(":lcd " .. root)
    end
  end,
  desc = "Set root dir and initialize version control branch",
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
    if vim.bo.filetype == "oil" then return end

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


---- Automatic text generation for specific files
local top_message = os.date("// Created: %Y-%m-%d %H:%M:%S");

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

-- jump target indicator
do
  local ns = vim.api.nvim_create_namespace("jump_target")

  aucmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
    group = augrp("jump-target-indicator", { clear = true }),
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local row   = vim.api.nvim_win_get_cursor(0)[1]

      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

      local target = require("helper").scope_jump(1, true)
      if not target or target == row then return end

      vim.api.nvim_buf_set_extmark(bufnr, ns, target - 1, 0, {
        virt_text     = { { " J", "Comment" } },
        virt_text_pos = "eol",
        priority      = 100,
      })
    end,
  })
end

