local keymaps = require('demicolon.keymaps')
local move = require('demicolon.move')

local M = {}

---@class DemicolonOptions
local options = {
  diagnostic = {
    ---@type vim.diagnostic.Opts.Float Default options passed to diagnostic floating window
    float = {}
  },
  keymaps = {
    default = {
      --- Create `t`/`T`/`f`/`F` key mappings
      horizontal_motions = true,
      --- Create ]d/[d, etc. key mappings to move to diganostics
      --- @see demicolon.keymaps.create_default_diagnostic_keymaps
      diagnostic_motions = true,
      --- Create `;` and `,` key mappings
      repeat_motions = true,
    },
  },
}

---@return DemicolonOptions
function M.get_options()
  return options
end

---@param opts DemicolonOptions
function M.setup(opts)
  options = vim.tbl_deep_extend('force', options, opts or {})

  if options.keymaps.default.horizontal_motions then
    keymaps.create_default_horizontal_keymaps()
  end

  if options.keymaps.default.repeat_motions then
    keymaps.create_default_repeat_keymaps()
  end

  if options.keymaps.default.diagnostic_motions then
    keymaps.create_default_diagnostic_keymaps()
  end
end

M.diagnostic_move = move.diagnostic_move_repeatably

return M
