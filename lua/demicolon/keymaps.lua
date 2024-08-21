local jump = require('demicolon.jump')
local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

local nxo = { 'n', 'x', 'o' }
local expr = { expr = true }

function M.create_default_repeat_keymaps()
  vim.keymap.set(nxo, ';', ts_repeatable_move.repeat_last_move_next)
  vim.keymap.set(nxo, ',', ts_repeatable_move.repeat_last_move_previous)
end

function M.create_default_horizontal_keymaps()
  vim.keymap.set(nxo, 'f', jump.horizontal_jump('f'), expr)
  vim.keymap.set(nxo, 'F', jump.horizontal_jump('F'), expr)
  vim.keymap.set(nxo, 't', jump.horizontal_jump('t'), expr)
  vim.keymap.set(nxo, 'T', jump.horizontal_jump('T'), expr)
end

function M.create_default_diagnostic_keymaps()
  vim.keymap.set(nxo, ']d', jump.diagnostic_jump({ forward = true }))
  vim.keymap.set(nxo, '[d', jump.diagnostic_jump({ forward = false }))
  vim.keymap.set(nxo, ']e', jump.diagnostic_jump({ forward = true, severity = 'ERROR' }))
  vim.keymap.set(nxo, '[e', jump.diagnostic_jump({ forward = false, severity = 'ERROR' }))
  vim.keymap.set(nxo, ']w', jump.diagnostic_jump({ forward = true, severity = 'WARN' }))
  vim.keymap.set(nxo, '[w', jump.diagnostic_jump({ forward = false, severity = 'WARN' }))
  vim.keymap.set(nxo, ']i', jump.diagnostic_jump({ forward = true, severity = 'INFO' }))
  vim.keymap.set(nxo, '[i', jump.diagnostic_jump({ forward = false, severity = 'INFO' }))
  vim.keymap.set(nxo, ']h', jump.diagnostic_jump({ forward = true, severity = 'HINT' }))
  vim.keymap.set(nxo, '[h', jump.diagnostic_jump({ forward = false, severity = 'HINT' }))
end

return M
