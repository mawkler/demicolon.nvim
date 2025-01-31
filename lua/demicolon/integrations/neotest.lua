local M = {}

---@param options { forward?: boolean, neotest_args?: neotest.jump.JumpArgs }
function M.jump(options)
  return function()
    require('demicolon.jump').repeatably_do(function(opts)
      local exists, neotest = pcall(require, 'neotest')
      if not exists then
        vim.notify('demicolon.nvim: neotest is not installed', vim.log.levels.WARN)
        return
      end

      local direction = (opts.forward == nil or opts.forward) and 'next' or 'prev'
      neotest.jump[direction](options.neotest_args)
    end, options)
  end
end

function M.create_keymaps()
  local map = vim.keymap.set

  local options = require('demicolon').get_options().integrations.neotest
  if not options or not options.enabled or not options.keymaps then
    return
  end

  local nxo = { 'n', 'x', 'o' }

  map(nxo, options.keymaps.test.next, M.jump({ forward = true }), { desc = 'Next test' })
  map(nxo, options.keymaps.test.prev, M.jump({ forward = false }), { desc = 'Previous test' })

  local failed = { status = 'failed' }
  map(nxo, options.keymaps.failed_test.next, M.jump({ forward = true, neotest_args = failed }),
    { desc = 'Next failed test' }
  )
  map(nxo, options.keymaps.failed_test.prev, M.jump({ forward = false, neotest_args = failed }),
    { desc = 'Previous failed test' })
end

return M
