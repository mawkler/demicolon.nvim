local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

---@class DemicolonOptions
local options = {
  diagnostic = {
    ---@type vim.diagnostic.Opts.Float
    float = {}
  }
}

local function move_repeatably(key)
  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

local nxo = { 'n', 'x', 'o' }
local expr = { expr = true }

local function create_default_keymaps()
  vim.keymap.set(nxo, 'f', move_repeatably('f'), expr)
  vim.keymap.set(nxo, 'F', move_repeatably('F'), expr)
  vim.keymap.set(nxo, 't', move_repeatably('t'), expr)
  vim.keymap.set(nxo, 'T', move_repeatably('T'), expr)

  vim.keymap.set(nxo, ';', ts_repeatable_move.repeat_last_move_next)
  vim.keymap.set(nxo, ',', ts_repeatable_move.repeat_last_move_previous)
end

local function create_default_diagnostic_keymaps()
  vim.keymap.set(nxo, ']d', M.diagnostic_move_repeatable(true))
  vim.keymap.set(nxo, '[d', M.diagnostic_move_repeatable(false))
  vim.keymap.set(nxo, ']h', M.diagnostic_move_repeatable(true, { severity = 'HINT' }))
  vim.keymap.set(nxo, '[h', M.diagnostic_move_repeatable(false, { severity = 'HINT' }))
  vim.keymap.set(nxo, ']w', M.diagnostic_move_repeatable(true, { severity = 'WARN' }))
  vim.keymap.set(nxo, '[w', M.diagnostic_move_repeatable(false, { severity = 'WARN' }))
  vim.keymap.set(nxo, ']e', M.diagnostic_move_repeatable(true, { severity = 'ERROR' }))
  vim.keymap.set(nxo, '[e', M.diagnostic_move_repeatable(false, { severity = 'ERROR' }))
end

---@param forward boolean
---@param opts vim.diagnostic.JumpOpts?
local function diagnostic_move(forward, opts)
  opts = opts or {}
  opts.float = vim.tbl_extend('force', opts, options.diagnostic.float)

  local direction = forward and 'next' or 'prev'
  vim.diagnostic['goto_' .. direction](opts)
end

---@param forward boolean
---@param opts vim.diagnostic.JumpOpts?
function M.diagnostic_move_repeatable(forward, opts)
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

---@param opts DemicolonOptions
function M.setup(opts)
  options = vim.tbl_deep_extend('force', options, opts or {})

  create_default_keymaps()
  create_default_diagnostic_keymaps()
end

return M
