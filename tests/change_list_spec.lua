---@param T table Test helpers from `tests/init.lua`
return function(T)
  local normal_cmd = require('demicolon.utils').normal_cmd

  -- Creates changes on lines 2, 4, 6, and 8
  local function make_changes()
    T.set_buf(vim.fn['repeat']({ 'x' }, 10))
    for _, lnum in ipairs({ 2, 4, 6, 8 }) do
      normal_cmd(lnum .. 'GAy')
      -- Break the undo sequence so that each change gets its own entry
      vim.o.undolevels = vim.o.undolevels
    end
    normal_cmd('10G')
  end

  local function lines_after(keys)
    return vim.tbl_map(function(key)
      T.feed(key)
      return T.cursor()[1]
    end, keys)
  end

  -- `g;` counts as forward, so stateless and stateful behave the same here
  local keys = { 'g;', ';', ',', '2g;', 'g,' }
  local expected = { 8, 6, 8, 4, 6 }

  for _, mode in ipairs({ 'stateless', 'stateful' }) do
    T.setup(mode)

    T.it(mode .. ': g;/g, then ; and ,', function()
      make_changes()
      T.eq(expected, lines_after(keys))
    end)

    T.it(mode .. ': error at the start of the change list', function()
      make_changes()
      T.feed('999g;')
      T.eq(2, T.cursor()[1])
      vim.cmd('messages clear')
      T.feed('g;')
      T.eq('E662: At start of changelist', vim.trim(vim.fn.execute('1messages')))
    end)
  end
end
