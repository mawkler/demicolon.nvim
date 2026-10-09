local normal_cmd = require('demicolon.utils').normal_cmd
local repeatability = require('demicolon.repeatability')

local M = {}

---@class demicolon.jump.opts
---@field forward boolean `true` if the jump is forwards, `false` if it is backwards
---@field repeated? boolean `true` if the jump was repeated with `;`/`,`

---@param func fun(opts: (demicolon.jump.opts | table), additional_args?: ...) Repeatable function to be called. It should determine by the `forward` boolean whether to move forward or backward
---@param opts demicolon.jump.opts | table Options to pass to the function. Make sure to include the `forward` boolean
---@param additional_args? any[]
function M.repeatably_do(func, opts, additional_args)
  opts, additional_args = opts or {}, additional_args or {}
  repeatability.set_last_move(func, opts, unpack(additional_args))
  func(opts, unpack(additional_args))
end

---@param key 't' | 'T' | 'f' | 'F'
---@return fun(): string
function M.horizontal_jump(key)
  return function()
    return repeatability.horizontal_expr(key)
  end
end

---@param opts demicolon.jump.opts
local function change_list_jump(opts)
  local key = opts.forward and 'g;' or 'g,'
  local ok, err = pcall(normal_cmd, vim.v.count1 .. key)
  if not ok then
    -- Only show the error itself, like Neovim does natively, without the
    -- `Vim(normal):` prefix and Lua context
    local message = tostring(err):match('E%d+:.*') or tostring(err)
    vim.api.nvim_echo({ { message, 'ErrorMsg' } }, true, {})
  end
end

--- Jump to an older (`g;`) or newer (`g,`) position in the change list
---@param key 'g;' | 'g,'
---@return fun()
function M.change_list_jump(key)
  return function()
    M.repeatably_do(change_list_jump, { forward = key == 'g;' })
  end
end

return M
