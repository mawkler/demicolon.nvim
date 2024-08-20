local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

---@param key 't' | 'T' | 'f' | 'F'
---@return fun(): string
function M.horizontal_jump_repeatably(key)
  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

---@class DemicolonDiagnosticJumpOpts: vim.diagnostic.JumpOpts
---@field forward boolean

---@param opts DemicolonDiagnosticJumpOpts?
local function diagnostic_jump(opts)
  opts = opts or {}
  local options = require('demicolon').get_options()
  opts.float = vim.tbl_extend('force', opts, options.diagnostic.float)

  local count = opts.forward and 1 or -1
  opts.count = count * vim.v.count1

  vim.diagnostic.jump(opts)
end

---@param func fun(opts: table | { forward: boolean }) Repeatable function to be called. It should determine by the `forward` boolean whether to move forward or backward
---@param opts table | { forward: boolean } Options to pass to the function. Make sure to include the `forward` boolean
function M.repeatably_do(func, opts)
  opts = opts or {}
  ts_repeatable_move.last_move = {
    func = func,
    opts = opts,
    additional_args = {},
  }

  func(opts)
end

---@param opts DemicolonDiagnosticJumpOpts Note that the `count` field will be overridden by `vim.v.count1`
---@return function
function M.diagnostic_jump_repeatably(opts)
  return function()
    M.repeatably_do(diagnostic_jump, opts)
  end
end

return M
