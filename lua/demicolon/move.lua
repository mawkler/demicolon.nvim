local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

---@param key string
---@return function
function M.ts_move_repeatably(key)
  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

---@param forward boolean
---@param opts vim.diagnostic.JumpOpts?
local function diagnostic_move(forward, opts)
  opts = opts or {}
  opts.float = vim.tbl_extend('force', opts, require('demicolon').get_options().diagnostic.float)

  local direction = forward and 'next' or 'prev'
  vim.diagnostic['goto_' .. direction](opts)
end

---@param forward boolean
---@param opts vim.diagnostic.JumpOpts?
---@return function
function M.diagnostic_move_repeatably(forward, opts)
  return function()
    ts_repeatable_move.last_move = {
      func = function(o)
        diagnostic_move(o.forward, o)
      end,
      opts = { forward = forward },
      additional_args = {},
    }

    diagnostic_move(forward, opts)
  end
end

return M
