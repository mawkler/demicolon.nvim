local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')

vim.opt.runtimepath:prepend(root)

local T = { root = root, failures = 0 }

--- `print` doesn't end lines when running with `nvim -l`
function T.print(message)
  io.stdout:write(message .. '\n')
end

---@param mode 'stateless' | 'stateful'
---@param opts? demicolon.options
function T.setup(mode, opts)
  opts = vim.tbl_deep_extend('force', { keymaps = { repeat_motions = mode } }, opts or {})
  require('demicolon').setup(opts)
end

---@param name string
---@param fn fun()
---@param opts? { xfail: boolean } `xfail` marks a test that is expected to fail
function T.it(name, fn, opts)
  local xfail = opts and opts.xfail

  vim.cmd('enew!')
  vim.bo.bufhidden = 'wipe'
  local ok, err = pcall(fn)

  if xfail then
    if ok then
      T.failures = T.failures + 1
      T.print('XPASS ' .. name .. ' (remove the xfail marker)')
    else
      T.print('XFAIL ' .. name)
    end
  elseif ok then
    T.print('PASS  ' .. name)
  else
    T.failures = T.failures + 1
    T.print('FAIL  ' .. name .. '\n      ' .. tostring(err):gsub('\n', '\n      '))
  end
end

---@param keys string Keys to type, with mappings applied
function T.feed(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), 'mtx', false)
end

---@param lines string[]
---@param cursor? [integer, integer] (1,0)-indexed
function T.set_buf(lines, cursor)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, cursor or { 1, 0 })
end

---@return [integer, integer]
function T.cursor()
  return vim.api.nvim_win_get_cursor(0)
end

function T.eq(expected, actual, message)
  if not vim.deep_equal(expected, actual) then
    error(
      string.format('%sexpected %s, got %s', message and message .. ': ' or '', vim.inspect(expected),
        vim.inspect(actual)),
      2
    )
  end
end

return T
