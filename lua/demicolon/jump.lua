local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

---@param func fun(opts: (table | { forward: boolean }), additional_args?: ...) Repeatable function to be called. It should determine by the `forward` boolean whether to move forward or backward
---@param opts table | { forward: boolean } Options to pass to the function. Make sure to include the `forward` boolean
---@param additional_args? any[]
function M.repeatably_do(func, opts, additional_args)
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
  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

---@deprecated Use horizontal_jump instead
function M.horizontal_jump_repeatably(opts)
  vim.notify('diagnostic.nvim: `horizontal_jump_repeatably` is deprecated. Use `horizontal_jump` instead.')
  return M.horizontal_jump(opts)
end

---@class DemicolonDiagnosticJumpOpts: vim.diagnostic.JumpOpts
---@field forward boolean

---@param opts DemicolonDiagnosticJumpOpts Note that the `count` field will be overridden by `vim.v.count1`
---@return function
function M.diagnostic_jump(opts)
  return function()
    M.repeatably_do(function(o)
      o = o or {}
      local options = require('demicolon').get_options()
      o.float = vim.tbl_extend('force', o, options.diagnostic.float)

      local count = o.forward and 1 or -1
      o.count = count * vim.v.count1

      if vim.diagnostic.jump then
        vim.diagnostic.jump(o)
      else
        -- Deprecated in favor of `vim.diagnostic.jump` in Neovim 0.11.0
        vim.diagnostic.goto_next(o)
      end
    end, opts)
  end
end

---@deprecated Use `diagnostic_jump` instead
function M.diagnostic_jump_repeatably(opts)
  vim.notify('diagnostic.nvim: `diagnostic_jump_repeatably` is deprecated. Use `diagnostic_jump` instead.')
  return M.diagnostic_jump(opts)
end

return M
