local move = require('demicolon.move')
local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

local nxo = { 'n', 'x', 'o' }
local expr = { expr = true }

function M.create_default_repeat_keymaps()
  vim.keymap.set(nxo, ';', ts_repeatable_move.repeat_last_move_next)
  vim.keymap.set(nxo, ',', ts_repeatable_move.repeat_last_move_previous)
end

function M.create_default_horizontal_keymaps()
  vim.keymap.set(nxo, 'f', move.ts_move_repeatably('f'), expr)
  vim.keymap.set(nxo, 'F', move.ts_move_repeatably('F'), expr)
  vim.keymap.set(nxo, 't', move.ts_move_repeatably('t'), expr)
  vim.keymap.set(nxo, 'T', move.ts_move_repeatably('T'), expr)
end

function M.create_default_diagnostic_keymaps()
  vim.keymap.set(nxo, ']d', move.diagnostic_move_repeatably(true))
  vim.keymap.set(nxo, '[d', move.diagnostic_move_repeatably(false))
  vim.keymap.set(nxo, ']h', move.diagnostic_move_repeatably(true, { severity = 'HINT' }))
  vim.keymap.set(nxo, '[h', move.diagnostic_move_repeatably(false, { severity = 'HINT' }))
  vim.keymap.set(nxo, ']w', move.diagnostic_move_repeatably(true, { severity = 'WARN' }))
  vim.keymap.set(nxo, '[w', move.diagnostic_move_repeatably(false, { severity = 'WARN' }))
  vim.keymap.set(nxo, ']e', move.diagnostic_move_repeatably(true, { severity = 'ERROR' }))
  vim.keymap.set(nxo, '[e', move.diagnostic_move_repeatably(false, { severity = 'ERROR' }))
end

return M
