---@param T table Test helpers from `tests/init.lua`
return function(T)
  local repeatably_do = require('demicolon.jump').repeatably_do

  local calls
  local function record(opts, ...)
    table.insert(calls, { opts = opts, args = { ... } })
  end

  for _, mode in ipairs({ 'stateless', 'stateful' }) do
    T.setup(mode)

    T.it(mode .. ': custom jump is called and repeated', function()
      calls = {}
      repeatably_do(record, { forward = false, custom = 1 }, { 'a', 'b' })
      T.feed(';')
      T.feed(',')

      T.eq({ forward = false, custom = 1 }, calls[1].opts)
      T.eq({ 'a', 'b' }, calls[1].args)

      -- Stateful `;` repeats the original (backward) direction
      local forward = mode == 'stateless'
      T.eq({ forward = forward, custom = 1, repeated = true }, calls[2].opts)
      T.eq({ forward = not forward, custom = 1, repeated = true }, calls[3].opts)
      T.eq({ 'a', 'b' }, calls[3].args)
    end)

    T.it(mode .. ': mutating opts after the jump does not affect repeats', function()
      calls = {}
      local opts = { forward = true, custom = 1 }
      repeatably_do(record, opts)
      opts.custom = 2
      T.feed(';')
      T.eq(1, calls[2].opts.custom)
    end)
  end
end
