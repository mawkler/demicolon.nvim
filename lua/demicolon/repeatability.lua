-- Adapted from nvim-treesitter-textobjects' `repeatable_move.lua`
-- (https://github.com/nvim-treesitter/nvim-treesitter-textobjects, Apache-2.0)

local normal_cmd = require('demicolon.util').normal_cmd

local M = {}

---@alias demicolon.repeatability.func fun(opts: demicolon.jump.opts | table, ...: any)

---@class demicolon.repeatability.Move
---@field func demicolon.repeatability.func
---@field opts demicolon.jump.opts | table
---@field additional_args any[]

---@type demicolon.repeatability.Move?
M.last_move = nil

--- Store `func` as the last move, without calling it
---@param func demicolon.repeatability.func
---@param opts demicolon.jump.opts | table
---@param ... any Additional arguments to pass to `func`
function M.set_last_move(func, opts, ...)
  M.last_move = { func = func, opts = vim.deepcopy(opts), additional_args = { ... } }
end

--- Repeat the last move, with `opts_extend` overriding its original options
---@param opts_extend? demicolon.jump.opts | table
function M.repeat_last_move(opts_extend)
  if not M.last_move then
    return
  end

  local opts = vim.tbl_deep_extend('force', M.last_move.opts, opts_extend or {})
  M.last_move.func(opts, unpack(M.last_move.additional_args))
end

--- Repeat the last f/F/t/T with native `;`/`,`.
---
--- Natively, `;`/`,` are inclusive when they move forward and exclusive when
--- they move backward. But in operator-pending mode, a cursor movement made by
--- a mapping is always exclusive. This compensates for that, so that for
--- example `y;` and `yv;` behave like they do natively.
---@param opts demicolon.jump.opts
---@param original_forward boolean Whether the repeated f/F/t/T jump was forward
local function repeat_horizontal(opts, original_forward)
  -- `;` repeats in the original direction, `,` in the opposite direction
  local motion = vim.v.count1 .. (opts.forward == original_forward and ';' or ',')

  local mode = vim.api.nvim_get_mode().mode
  -- `v`, `V` or `CTRL-V` typed after the operator (`:h forced-motion`), if any
  local forced = mode:sub(3)

  -- An exclusive cursor movement already matches native `;`/`,` here
  if mode:sub(1, 2) ~= 'no' or not opts.forward then
    normal_cmd(motion)
    return
  end

  local cursor_before = vim.api.nvim_win_get_cursor(0)

  if forced == '' then
    -- Make the motion inclusive by selecting it with Visual mode, but not if
    -- the cursor didn't move, since that would select the character under it
    normal_cmd('v' .. motion)
    if vim.deep_equal(vim.api.nvim_win_get_cursor(0), cursor_before) then
      normal_cmd('v')
    end
  else
    normal_cmd(motion)

    -- Natively, `v` toggles `;` from inclusive to exclusive. Here it toggles
    -- the exclusive cursor movement to inclusive instead, so exclude the
    -- target character to compensate
    local cursor_after = vim.api.nvim_win_get_cursor(0)
    if forced == 'v' and not vim.deep_equal(cursor_after, cursor_before) then
      vim.api.nvim_win_set_cursor(0, { cursor_after[1], cursor_after[2] - 1 })
    end
  end
end

--- Store `key` as the last move and return it. Meant for `{ expr = true }` mappings.
---@param key 'f' | 'F' | 't' | 'T'
---@return string
function M.horizontal_expr(key)
  local forward = key == 'f' or key == 't'
  -- `opts.forward` gets overridden when repeating, so the original direction
  -- is passed as a separate argument
  M.set_last_move(repeat_horizontal, { forward = forward }, forward)
  return key
end

return M
