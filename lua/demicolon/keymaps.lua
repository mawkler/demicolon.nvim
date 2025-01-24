local jump = require('demicolon.jump')
local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')
local map = vim.keymap.set

local M = {}

local nxo = { 'n', 'x', 'o' }
local expr = { expr = true }

function M.create_default_repeat_keymaps()
  map(nxo, ';', require('demicolon.repeat_jump').forward)
  map(nxo, ',', require('demicolon.repeat_jump').backward)
end

function M.create_default_horizontal_keymaps()
  map(nxo, 'f', jump.horizontal_jump('f'), expr)
  map(nxo, 'F', jump.horizontal_jump('F'), expr)

  map(nxo, 't', jump.horizontal_jump('t'), expr)
  map(nxo, 'T', jump.horizontal_jump('T'), expr)
end

function M.create_default_diagnostic_keymaps()
  local jump = jump.diagnostic_jump

  map(nxo, ']d', jump({ forward = true }), { desc = 'Next diagnostic' })
  map(nxo, '[d', jump({ forward = false }), { desc = 'Previous diagnostic' })

  map(nxo, ']e', jump({ forward = true, severity = 'ERROR' }), { desc = 'Next error' })
  map(nxo, '[e', jump({ forward = false, severity = 'ERROR' }), { desc = 'Previous error' })

  map(nxo, ']w', jump({ forward = true, severity = 'WARN' }), { desc = 'Next warning' })
  map(nxo, '[w', jump({ forward = false, severity = 'WARN' }), { desc = 'Previous warning' })

  map(nxo, ']i', jump({ forward = true, severity = 'INFO' }), { desc = 'Next info' })
  map(nxo, '[i', jump({ forward = false, severity = 'INFO' }), { desc = 'Previous info' })

  map(nxo, ']h', jump({ forward = true, severity = 'HINT' }), { desc = 'Next hint' })
  map(nxo, '[h', jump({ forward = false, severity = 'HINT' }), { desc = 'Previous hint' })
end

function M.create_default_list_keymaps()
  local qf_jump = jump.quickfix_list_jump

  map(nxo, ']q', qf_jump({ forward = true }), { desc = 'Next quickfix list item' })
  map(nxo, '[q', qf_jump({ forward = false }), { desc = 'Previous quickfix list item' })
  map(nxo, ']<C-q>', qf_jump({ forward = true, file = true }), { desc = 'Next quickfix list file' })
  map(nxo, '[<C-q>', qf_jump({ forward = false, file = true }), { desc = 'Previous quickfix list file' })

  local ll_jump = jump.location_list_jump

  map(nxo, ']l', ll_jump({ forward = true }), { desc = 'Next location list item' })
  map(nxo, '[l', ll_jump({ forward = false }), { desc = 'Previous location list item' })
  map(nxo, ']<C-l>', ll_jump({ forward = true, file = true }), { desc = 'Next location list file' })
  map(nxo, '[<C-l>', ll_jump({ forward = false, file = true }), { desc = 'Previous location list file' })
end

function M.create_default_spell_keymaps()
  map(nxo, ']s', jump.spell_jump({ forward = true }), { desc = 'Next spellning mistake' })
  map(nxo, '[s', jump.spell_jump({ forward = false }), { desc = 'Previous spellning mistake' })
end

function M.create_default_fold_keymaps()
  map(nxo, ']z', jump.fold_jump({ forward = true }), { desc = 'Next fold' })
  map(nxo, '[z', jump.fold_jump({ forward = false }), { desc = 'Previous fold' })
end

return M
