local M = {}

---@class demicolon.jump.opts
---@field forward boolean `true` if the jump is forwards, `false` if it is backwards
---@field repeated? boolean `true` if the jump was repeated with `;`/`,`

---@param func fun(opts: (demicolon.jump.opts | table), additional_args?: ...) Repeatable function to be called. It should determine by the `forward` boolean whether to move forward or backward
---@param opts demicolon.jump.opts | table Options to pass to the function. Make sure to include the `forward` boolean
---@param additional_args? any[]
function M.repeatably_do(func, opts, additional_args)
  local ok, ts_repeatable_move = pcall(require, 'nvim-treesitter-textobjects.repeatable_move')
  if not ok then
    ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')
  end

  opts = opts or {}
  additional_args = additional_args or {}
  ts_repeatable_move.last_move = {
    func = func,
    opts = opts,
    additional_args = additional_args,
  }

  func(opts, unpack(additional_args))
end

---@param key 't' | 'T' | 'f' | 'F'
---@return fun(): string
function M.horizontal_jump(key)
  local ok, ts_repeatable_move = pcall(require, 'nvim-treesitter-textobjects.repeatable_move')
  if not ok then
    ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')
  end

  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

return M
