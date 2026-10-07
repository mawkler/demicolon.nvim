---@param T table Test helpers from `tests/init.lua`
return function(T)
  T.it('does not depend on nvim-treesitter or nvim-treesitter-textobjects', function()
    T.setup('stateless')
    T.set_buf({ 'a x b x' })
    T.feed('fx;,')
    require('demicolon.jump').repeatably_do(function() end, { forward = true })
    T.feed(';')

    for name in pairs(package.loaded) do
      assert(not name:find('^nvim%-treesitter'), 'Loaded ' .. name)
    end
  end)
end
