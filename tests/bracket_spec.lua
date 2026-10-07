---@param T table Test helpers from `tests/init.lua`
return function(T)
  local ns = vim.api.nvim_create_namespace('demicolon_test')

  local function set_diagnostics(lnums)
    vim.diagnostic.set(ns, 0, vim.tbl_map(function(lnum)
      return { lnum = lnum - 1, col = 0, message = 'test', severity = vim.diagnostic.severity.ERROR }
    end, lnums))
  end

  for _, mode in ipairs({ 'stateless', 'stateful' }) do
    T.setup(mode)

    T.it(mode .. ': ]d then ; and ,', function()
      T.set_buf(vim.fn['repeat']({ 'x' }, 10))
      set_diagnostics({ 2, 4, 6, 8 })
      T.feed(']d')
      T.eq(2, T.cursor()[1])
      T.feed(';')
      T.eq(4, T.cursor()[1])
      T.feed(',')
      T.eq(2, T.cursor()[1])
    end)

    T.it(mode .. ': [d then ; and ,', function()
      T.set_buf(vim.fn['repeat']({ 'x' }, 10), { 10, 0 })
      set_diagnostics({ 2, 4, 6, 8 })
      T.feed('[d')
      T.eq(8, T.cursor()[1])
      T.feed(';')
      -- Stateless `;` means `]d`, which wraps around to the first diagnostic
      T.eq(mode == 'stateless' and 2 or 6, T.cursor()[1])
    end)

    -- `])` jumps to the next unmatched `)`, and its opposite is `[(`.
    -- Currently broken: for non-remapped bracket motions `listen.lua` expects
    -- `mode()` to be `no` after the `]`, but it is `n`, also for real typed input.
    T.it(mode .. ': ]) is repeated backwards as [(', function()
      T.set_buf({ '( ( ( x ) ) )' }, { 1, 6 })
      T.feed('])')
      T.eq({ 1, 8 }, T.cursor())
      T.feed(';')
      T.eq({ 1, 10 }, T.cursor())
      T.feed(',')
      T.eq({ 1, 0 }, T.cursor())
    end, { xfail = true })

    T.it(mode .. ': disabled keys are not repeatable', function()
      T.set_buf(vim.fn['repeat']({ 'x' }, 10))
      set_diagnostics({ 2, 4, 6, 8 })
      T.feed(']d')
      vim.fn.setreg('"', 'pasted\n', 'l')
      T.feed(']p')
      T.eq('pasted', vim.fn.getline(3))
      -- The diagnostic on line 4 is now on line 5
      T.feed(';')
      T.eq(5, T.cursor()[1])
    end)
  end
end
