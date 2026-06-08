local M = {}

-- shared brace utilities

local function make_buf_utils(bufnr, total)
  local function get_line(r)
    return vim.api.nvim_buf_get_lines(bufnr, r - 1, r, false)[1] or ""
  end

  local function is_blank(r)       return get_line(r):match("^%s*$") ~= nil end
  local function is_open_brace(r)  return get_line(r):match("^%s*{%s*$") ~= nil end
  local function is_close_brace(r) return get_line(r):match("^%s*}") ~= nil end

  local function indent(r)
    local l = get_line(r)
    if l:match("^%s*$") then return nil end
    return #l:match("^(%s*)")
  end

  local function first_nonblank(r, dir)
    local i = r
    while i >= 1 and i <= total do
      if not is_blank(i) then return i end
      i = i + dir
    end
    return nil
  end

  local function is_comment(r)
    local l = get_line(r)
    return l:match("^%s*//") ~= nil
        or l:match("^%s*/%*") ~= nil
        or l:match("^%s*%*")  ~= nil
  end

  local function is_signature(r)
    local l = get_line(r)
    if not l:match("[%w_]") then return false end
    if l:match(";%s*$")     then return false end
    if is_comment(r)        then return false end

    local i = r + 1
    while i <= total do
      if is_blank(i) then
        i = i + 1
      elseif is_open_brace(i) then
        return true
      elseif is_close_brace(i) then
        return false
      else
        if is_comment(i)               then return false end
        if get_line(i):match(";%s*$")  then return false end
        i = i + 1
      end
    end
    return false
  end

  local function find_matching_close(r)
    local depth = 1
    local i = r + 1
    while i <= total do
      if   is_open_brace(i)  then depth = depth + 1
      elseif is_close_brace(i) then
        depth = depth - 1
        if depth == 0 then return i end
      end
      i = i + 1
    end
    return nil
  end

  local function find_matching_open(r)
    local depth = 1
    local i = r - 1
    while i >= 1 do
      if   is_close_brace(i) then depth = depth + 1
      elseif is_open_brace(i)  then
        depth = depth - 1
        if depth == 0 then return i end
      end
      i = i - 1
    end
    return nil
  end

  return {
    get_line            = get_line,
    is_blank            = is_blank,
    is_open_brace       = is_open_brace,
    is_close_brace      = is_close_brace,
    indent              = indent,
    first_nonblank      = first_nonblank,
    is_comment          = is_comment,
    is_signature        = is_signature,
    find_matching_close = find_matching_close,
    find_matching_open  = find_matching_open,
  }
end

-- scope_jump

function M.scope_jump(direction, dry_run)
  local bufnr = 0
  local row   = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(bufnr)
  local u     = make_buf_utils(bufnr, total)

  local function jump(r)
    if dry_run then return r end
    vim.api.nvim_win_set_cursor(0, { r, u.indent(r) or 0 })
  end

  if vim.fn.expand("%:e") == "h" then
    if not dry_run then
      local key = direction == 1 and "}" or "{"
      vim.api.nvim_feedkeys(key, "n", false)
    end
    return nil
  end

  if direction == 1 then
    local cur_open, cur_close

    do
      local depth = 0
      for i = row, 1, -1 do
        if   u.is_close_brace(i) then depth = depth + 1
        elseif u.is_open_brace(i)  then
          if depth == 0 then cur_open = i break
          else depth = depth - 1
          end
        end
      end
    end

    if cur_open then cur_close = u.find_matching_close(cur_open) end

    local i = row + 1
    while i <= total do
      if u.is_comment(i)  then i = i + 1 goto continue end
      if u.is_open_brace(i) then
        if cur_close and i > cur_close then
          local after = u.first_nonblank(cur_close + 1, 1)
          if after and u.is_open_brace(after) then
            local inside = u.first_nonblank(after + 1, 1)
            if inside then return jump(inside) end
          elseif after then
            return jump(after)
          end
        end

        local inside = u.first_nonblank(i + 1, 1)
        if inside and (not cur_close or inside < cur_close) then
          return jump(inside)
        end

        local close = u.find_matching_close(i)
        if close then i = close + 1 else i = i + 1 end
        goto continue
      end

      if u.is_close_brace(i) then
        local after = i + 1
        while after <= total do
          if u.is_blank(after) then
            after = after + 1
          elseif u.is_comment(after) then
            after = after + 1
          elseif u.is_signature(after) then
            while after <= total and not u.is_open_brace(after) do
              after = after + 1
            end
            if after <= total and u.is_open_brace(after) then
              local close  = u.find_matching_close(after)
              local inside = u.first_nonblank(after + 1, 1)
              if inside and (not close or inside < close) then
                return jump(inside)
              end
              if close and close > after + 1 then
                return jump(after + 1)
              else
                return jump(after)
              end
            end
          elseif u.is_open_brace(after) then
            local close  = u.find_matching_close(after)
            local inside = u.first_nonblank(after + 1, 1)
            if inside and (not close or inside < close) then
              return jump(inside)
            end
            if close and close > after + 1 then
              return jump(after + 1)
            else
              return jump(after)
            end
          else
            return jump(after)
          end
        end
        return nil
      end

      i = i + 1
      ::continue::
    end

  else
    local i = row - 1
    while i >= 1 do
      if u.is_comment(i)   then i = i - 1 goto continue end
      if u.is_close_brace(i) then
        local open = u.find_matching_open(i)
        if open then
          local inside = u.first_nonblank(open + 1, 1)
          if inside and inside < row then
            return jump(inside)
          end
          i = open - 1
          goto continue
        end
      end

      if u.is_open_brace(i) then
        local inside = u.first_nonblank(i + 1, 1)
        if inside and inside < row then
          return jump(inside)
        end
        i = i - 1
        goto continue
      end

      i = i - 1
      ::continue::
    end
  end

  return nil
end

-- generate_enum_flags

function M.generate_enum_flags()
  local bufnr  = 0
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start_line, end_line

  for i = cursor[1], 1, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match("^%s*typedef%s+enum") or line:match("^%s*enum") then
      start_line = i
      break
    end
  end

  if not start_line then
    vim.notify("Not inside an enum block", vim.log.levels.WARN)
    return
  end

  local total = vim.api.nvim_buf_line_count(bufnr)
  for i = start_line, total do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match("^%s*}") then end_line = i break end
  end

  if not end_line then
    vim.notify("Could not find closing brace of enum", vim.log.levels.WARN)
    return
  end

  local bit = 0
  for i = start_line + 1, end_line - 1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match("^%s*$") or line:match("^%s*//") or line:match("^%s*%*") then
      goto continue
    end
    local stripped = line:gsub("%s*=.-%s*,?%s*$", ""):gsub("%s*,%s*$", "")
    vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false,
      { stripped .. " = (1<<" .. bit .. ")," })
    bit = bit + 1
    ::continue::
  end
end

-- expand_function_declaration

M.storage_class_specifiers = {
  "auto", "extern", "internal", "local_persist", "register", "static",
}

M.compiler_hints = {
  "force_inline", "inline", "__forceinline", "__inline__",
  "__attribute__((always_inline))", "__declspec(noinline)",
}

M.return_type_defaults = {
  ["^void$"]      = nil,
  ["^[Bb]ool$"]   = "0",
  ["^b%d+$"]      = "0",
  ["^int$"]       = "0",
  ["^[Ss]%d+$"]   = "0",
  ["^i%d+$"]      = "0",
  ["^int%d+_t$"]  = "0",
  ["^long$"]      = "0",
  ["^short$"]     = "0",
  ["^char$"]      = "0",
  ["^[Uu]%d+$"]   = "0",
  ["^uint%d+_t$"] = "0",
  ["^unsigned$"]  = "0",
  ["^size_t$"]    = "0",
  ["^float$"]     = "0.f",
  ["^double$"]    = "0.0",
  ["^[Ff]%d+$"]   = "0.f",
  ["^String"]     = "{0}",
  ["^%u"]         = "{0}",
}

local function get_default_for_type(type_str)
  local t = type_str:match("^%s*(.-)%s*$")
  -- any pointer type (void *, U8 *, etc.) always gets 0
  if t:match("%*") then return "0" end
  for pattern, default in pairs(M.return_type_defaults) do
    if t:match(pattern) then return default end
  end
  return "{0}"
end

function M.expand_function_declaration()
  local bufnr = 0
  local count = math.max(1, vim.v.count)

  local function escape(s)
    return s:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1")
  end

  for _ = 1, count do
    local row  = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]

    local stripped = line:match("^%s*(.-)%s*;%s*$") or line:match("^%s*(.-)%s*$")
    if not stripped then
      vim.notify("Could not parse line", vim.log.levels.WARN)
      return
    end

    -- collect leading specifiers, preserving them
    local all_specifiers = {}
    for _, v in ipairs(M.storage_class_specifiers) do table.insert(all_specifiers, v) end
    for _, v in ipairs(M.compiler_hints)           do table.insert(all_specifiers, v) end

    local specifiers = {}
    local remainder  = stripped
    local changed    = true
    while changed do
      changed = false
      for _, spec in ipairs(all_specifiers) do
        local new = remainder:match("^" .. escape(spec) .. "%s+(.*)")
        if new then
          table.insert(specifiers, spec)
          remainder = new
          changed   = true
          break
        end
      end
    end

    -- remainder is now:  return_type func_name(params)
    -- may contain pointers e.g. "void *os_memory_reserve(U64 size)"
    local params_start = remainder:find("%b()")
    if not params_start then
      vim.notify("Could not find parameter list", vim.log.levels.WARN)
      return
    end

    local before_params = remainder:sub(1, params_start - 1):match("^(.-)%s*$")
    local params        = remainder:match("%b()")

    -- func_name is the last word token before '('
    -- everything before it (including any trailing *) is the return type
    local ret_type, func_name = before_params:match("^(.-)%s*%*?%s*([%w_]+)%s*$")

    -- if there was a * between return type and name, re-attach it to the type
    if before_params:match("%*") and ret_type and not ret_type:match("%*%s*$") then
      ret_type = ret_type:match("^(.-)%s*$") .. " *"
    end

    if not ret_type or not func_name then
      vim.notify("Could not parse return type / function name", vim.log.levels.WARN)
      return
    end

    local spec_prefix = #specifiers > 0 and (table.concat(specifiers, " ") .. " ") or ""

    local new_lines   = {}
    local sw          = vim.api.nvim_get_option_value("shiftwidth", { buf = bufnr })
    local indent_str  = string.rep(" ", sw)

    table.insert(new_lines, spec_prefix .. ret_type)  -- "internal void *"
    table.insert(new_lines, func_name .. params)       -- "os_memory_reserve(U64 size)"
    table.insert(new_lines, "{")

    local default = get_default_for_type(ret_type)
    if default ~= nil then
      local decl_type, decl_stars = ret_type:match("^(.-)(%s*%*+%s*)$")
      if decl_stars then
        table.insert(new_lines, indent_str .. decl_type .. decl_stars .. "result = " .. default .. ";")
      else
        table.insert(new_lines, indent_str .. ret_type .. " result = " .. default .. ";")
      end
      table.insert(new_lines, indent_str)
      table.insert(new_lines, indent_str .. "return result;")
    end

    table.insert(new_lines, "}")
    table.insert(new_lines, "")

    vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, new_lines)

    local next_decl = math.min(row + #new_lines, vim.api.nvim_buf_line_count(bufnr))
    vim.api.nvim_win_set_cursor(0, { next_decl, 0 })
  end
end

-- smart_split

function M.smart_split(vertical)
  local current_ext  = vim.fn.expand("%:e")
  local current_path = vim.fn.expand("%:p")
  local partner_ext  = current_ext == "h" and "c" or (current_ext == "c" and "h" or nil)

  if vertical then
    vim.cmd("vsplit")
  else
    vim.cmd("split")
  end

  if partner_ext then
    local partner_path = current_path:gsub("%." .. current_ext .. "$", "." .. partner_ext)
    if vim.fn.filereadable(partner_path) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(partner_path))
    end
  end
end

function M.get_enclosing_signature(bufnr, row, total)
  local u = make_buf_utils(bufnr, total)

  local control_flow = {
    "^if[%s%(]", "^for[%s%(]", "^while[%s%(]",
    "^switch[%s%(]", "^else", "^do[%s{]",
  }

  local function try_get_sig(open_brace)
    local sig_lines = {}
    local i = open_brace - 1
    while i >= 1 do
      local l = u.get_line(i)
      if u.is_blank(i)       then break end
      if u.is_close_brace(i) then break end
      if u.is_open_brace(i)  then break end
      if l:match("^%s*#")    then break end  -- stop at any preprocessor line
      if l:match("\\%s*$")   then break end  -- stop at macro continuation
      if u.is_comment(i)     then break end
      if l:match(";%s*$")    then break end
      table.insert(sig_lines, 1, l:match("^%s*(.-)%s*$"))
      i = i - 1
    end

    if #sig_lines == 0 then return nil end

    local text = table.concat(sig_lines, " ")
    local trimmed = text:match("^%s*(.-)%s*$")

    if not trimmed:match("%(") then return nil end
    if not trimmed:match("%)") then return nil end

    local control_flow = {
      "^if[%s%(]", "^for[%s%(]", "^while[%s%(]",
      "^switch[%s%(]", "^else", "^do[%s{]",
      "^if%(", "^for%(", "^while%(", "^switch%(",
    }
    for _, pat in ipairs(control_flow) do
      if trimmed:match(pat) then return nil end
    end

    local before_paren = trimmed:match("^(.-)%s*%(")
    if not before_paren then return nil end
    if not before_paren:match("[%w_]+%s*$") then return nil end

    for _, spec in ipairs(M.storage_class_specifiers) do
      trimmed = trimmed:gsub("^" .. spec .. "%s+", "")
    end
    for _, hint in ipairs(M.compiler_hints) do
      trimmed = trimmed:gsub("^" .. hint .. "%s+", "")
    end

    return { text = trimmed, line = open_brace - 1 }
  end

  local depth = 0
  local i = row
  local found = nil

  while i >= 1 do
    local l = u.get_line(i)

    -- only skip macro continuation lines (ending with \)
    -- do NOT skip standalone # directives — treat them as opaque stoppers
    if l:match("\\%s*$") then
      i = i - 1
      goto continue
    end

    -- a standalone preprocessor line is not a brace, just skip it
    if l:match("^%s*#") then
      i = i - 1
      goto continue
    end

    if u.is_close_brace(i) then
      depth = depth + 1
    elseif u.is_open_brace(i) then
      if depth == 0 then
        local sig = try_get_sig(i)
        if sig then
          found = sig
          break
        end
      else
        depth = depth - 1
      end
    end

    i = i - 1
    ::continue::
  end

  return found
end

return M
