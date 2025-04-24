local M = {}

local nxo = { 'n', 'x', 'o' }

function M.create_default_repeat_keymaps(direction)
  assert(type(direction) == "string" and (direction == 'stateless' or direction == 'stateful'), "repeat_motions must either be 'stateless' or 'stateful'")

  local repeat_jump = require('demicolon.repeat_jump')
  if direction == 'stateless' then
    vim.keymap.set(nxo, ';', repeat_jump.forward)
    vim.keymap.set(nxo, ',', repeat_jump.backward)
  else
    vim.keymap.set(nxo, ';', repeat_jump.next)
    vim.keymap.set(nxo, ',', repeat_jump.prev)
  end
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
