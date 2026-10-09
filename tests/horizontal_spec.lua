---@param T table Test helpers from `tests/init.lua`
return function(T)
  local normal_cmd = require('demicolon.utils').normal_cmd

  local line = 'x a x b x c x d x'

  --- Run the keys in `case` both natively and with Demicolon's mappings, and
  --- check that the buffer, cursor and unnamed register end up the same
  ---@param case { [integer]: string, line?: string, col?: integer, selection?: string }
  local function matches_native(case)
    vim.o.selection = case.selection or 'inclusive'

    local function run(feed)
      T.set_buf({ case.line or line }, { 1, case.col or 8 })
      vim.fn.setreg('"', '')
      for _, key in ipairs(case) do
        feed(key)
      end
      return {
        lines = vim.api.nvim_buf_get_lines(0, 0, -1, false),
        cursor = T.cursor(),
        register = vim.fn.getreg('"'),
      }
    end

    local expected = run(function(key) normal_cmd(vim.keycode(key)) end)
    local actual = run(T.feed)
    vim.o.selection = 'inclusive'

    T.eq(expected, actual, table.concat(case, ' '))
  end

  for _, mode in ipairs({ 'stateless', 'stateful' }) do
    T.setup(mode)

    T.it(mode .. ': f then ; and ,', function()
      T.set_buf({ line })
      T.feed('fx')
      T.eq({ 1, 4 }, T.cursor())
      T.feed(';')
      T.eq({ 1, 8 }, T.cursor())
      T.feed(',')
      T.eq({ 1, 4 }, T.cursor())
    end)

    T.it(mode .. ': F then ; and ,', function()
      T.set_buf({ line }, { 1, 12 })
      T.feed('Fx')
      T.eq({ 1, 8 }, T.cursor())
      -- Stateless `;` always goes right, stateful `;` goes in the direction of `F`
      T.feed(';')
      T.eq(mode == 'stateless' and { 1, 12 } or { 1, 4 }, T.cursor())
      T.feed(',')
      T.eq({ 1, 8 }, T.cursor())
    end)

    T.it(mode .. ': count with ;', function()
      T.set_buf({ line })
      T.feed('fx')
      T.feed('2;')
      T.eq({ 1, 12 }, T.cursor())
    end)

    -- In stateless mode `;`/`,` mean right/left, so they only match native
    -- `;`/`,` after a forward jump
    local cases = {
      { 'fx', 'y;' }, { 'fx', 'y,' }, { 'tx', 'y;' }, { 'tx', 'y,' },
      { 'fx', 'yv;' }, { 'fx', 'yv,' }, { 'fx', 'yV;' }, { 'fx', 'y2;' },
      { 'tx', 'd;' },
      -- Dot-repeat
      { 'fx', 'd;', '.', col = 0 },
      { 'fx', 'c;new<Esc>', '.', col = 0 },
      -- `y;` is made inclusive with Visual mode, which shouldn't depend on 'selection'
      { 'fx', 'y;', selection = 'exclusive' },
      -- Multibyte characters
      { 'fx', 'yv;', line = 'a äx bäx cäx', col = 0 },
      { 'fä', 'y;', line = 'a ä b ä c ä', col = 0 },
    }
    if mode == 'stateful' then
      vim.list_extend(cases, {
        { 'Fx', 'y;' }, { 'Fx', 'y,' }, { 'Tx', 'y;' }, { 'Tx', 'y,' }, { 'Fx', 'yv;' },
      })
    end

    for _, case in ipairs(cases) do
      local name = table.concat(case, ' ')
          .. (case.line and (' in "' .. case.line .. '"') or '')
          .. (case.selection and (' with selection=' .. case.selection) or '')
      T.it(mode .. ': ' .. name .. ' matches native', function()
        matches_native(case)
      end)
    end
  end
end
