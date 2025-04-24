local M = {}

---@alias demicolon.jump.opts { forward: boolean }

---@param func fun(opts: (table | demicolon.jump.opts), additional_args?: ...) Repeatable function to be called. It should determine by the `forward` boolean whether to move forward or backward
---@param opts table | demicolon.jump.opts Options to pass to the function. Make sure to include the `forward` boolean
---@param additional_args? any[]
function M.repeatably_do(func, opts, additional_args)
  local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

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
  local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

return M
