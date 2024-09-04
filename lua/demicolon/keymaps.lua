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
  vim.keymap.set(nxo, ']d', jump.diagnostic_jump({ forward = true }), {desc = "Next diagnostic"})
  vim.keymap.set(nxo, '[d', jump.diagnostic_jump({ forward = false }), {desc = "Previous diagnostic"})
  vim.keymap.set(nxo, ']e', jump.diagnostic_jump({ forward = true, severity = 'ERROR' }), {desc = "Next error"})
  vim.keymap.set(nxo, '[e', jump.diagnostic_jump({ forward = false, severity = 'ERROR' }), {desc = "Previous error"})
  vim.keymap.set(nxo, ']w', jump.diagnostic_jump({ forward = true, severity = 'WARN' }), {desc = "Next warning"})
  vim.keymap.set(nxo, '[w', jump.diagnostic_jump({ forward = false, severity = 'WARN' }), {desc = "Previous warning"})
  vim.keymap.set(nxo, ']i', jump.diagnostic_jump({ forward = true, severity = 'INFO' }), {desc = "Next info"})
  vim.keymap.set(nxo, '[i', jump.diagnostic_jump({ forward = false, severity = 'INFO' }), {desc = "Previous info"})
  vim.keymap.set(nxo, ']h', jump.diagnostic_jump({ forward = true, severity = 'HINT' }), {desc = "Next hint"})
  vim.keymap.set(nxo, '[h', jump.diagnostic_jump({ forward = false, severity = 'HINT' }), {desc = "Previous hint"})
end

return M
