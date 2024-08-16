local M = {}

---@param options { forward: boolean }
function M.jump(options)
  return function()
    require('demicolon.jump').repeatably_do(function(opts)
      if vim.wo.diff then -- If we're in a diff
        local direction_key = (opts.forward == nil or opts.forward) and ']' or '['
        vim.cmd.normal({ vim.v.count1 .. direction_key .. 'c', bang = true })
      else
        local direction = (opts.forward == nil or opts.forward) and 'next' or 'prev'
        require('gitsigns').nav_hunk(direction)
      end
    end, options)
  end
end

function M.create_keymaps()
  local options = require('demicolon').get_options().integrations.gitsigns
  if options and not options.enabled then
    return
  end

  local nxo = { 'n', 'x', 'o' }

  ---@diagnostic disable-next-line: need-check-nil
  vim.keymap.set(nxo, options.keymaps.next, M.jump({ forward = true }))
  ---@diagnostic disable-next-line: need-check-nil
  vim.keymap.set(nxo, options.keymaps.prev, M.jump({ forward = false }))
end

return M
