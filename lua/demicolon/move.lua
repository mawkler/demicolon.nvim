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
  local options = require('demicolon').get_options()
  opts.float = vim.tbl_extend('force', opts, options.diagnostic.float)

  local direction = forward and 'next' or 'prev'
  vim.diagnostic['goto_' .. direction](opts)
end

---@param forward boolean
---@param opts vim.diagnostic.JumpOpts?
---@return function
-- TODO: change so that it takes only opts? Or not?
function M.diagnostic_move_repeatably(forward, opts)
  return function()
    ts_repeatable_move.last_move = {
      func = function(o)
        -- this only gets called if we're repeating ]d, etc., not if we're repating f/t, etc.
        diagnostic_move(o.forward, o)
      end,
      opts = { forward = forward, severity = opts and opts.severity },
      additional_args = {},
    }

    diagnostic_move(forward, opts)
  end
end

return M
