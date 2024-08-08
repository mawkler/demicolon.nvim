local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

---@param key 't' | 'T' | 'f' | 'F'
---@return fun(): string
function M.horizontal_jump_repeatably(key)
  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

---@param opts vim.diagnostic.JumpOpts?
local function diagnostic_jump(opts)
  opts = opts or {}
  local options = require('demicolon').get_options()
  opts.float = vim.tbl_extend('force', opts, options.diagnostic.float)

  vim.diagnostic.jump(opts)
end

---@param opts vim.diagnostic.JumpOpts
---@return function
function M.diagnostic_jump_repeatably(opts)
  return function()
    ts_repeatable_move.last_move = {
      func = function(o)
        local count = o.forward and 1 or -1
        o.count = count * vim.v.count1
        diagnostic_jump(o)
      end,
      opts = opts,
      additional_args = {},
    }

    local count = opts.count * vim.v.count1
    local opts_with_count = vim.tbl_deep_extend('force', opts, { count = count })

    diagnostic_jump(opts_with_count)
  end
end

return M
