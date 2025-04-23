local M = {}

local nxo = { 'n', 'x', 'o' }

function M.create_default_repeat_keymaps()
  vim.keymap.set(nxo, ';', require('demicolon.repeat_jump').forward)
  vim.keymap.set(nxo, ',', require('demicolon.repeat_jump').backward)
end

function M.create_default_horizontal_keymaps()
  local jump = require('demicolon.jump')
  local expr = { expr = true }

  vim.keymap.set(nxo, 'f', jump.horizontal_jump('f'), expr)
  vim.keymap.set(nxo, 'F', jump.horizontal_jump('F'), expr)

  vim.keymap.set(nxo, 't', jump.horizontal_jump('t'), expr)
  vim.keymap.set(nxo, 'T', jump.horizontal_jump('T'), expr)
end

return M
