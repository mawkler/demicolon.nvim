local keymaps = require('demicolon.keymaps')
local jump = require('demicolon.jump')

local M = {}

---@class DemicolonDiagnosticOptions
---@field float? vim.diagnostic.Opts.Float Default options passed to diagnostic floating window

---@class DemicolonKeymapsOptions
---@field horizontal_motions? boolean Create `t`/`T`/`f`/`F` key mappings
---@field diagnostic_motions? boolean Create ]d/[d, etc. key mappings to jump to diganostics. See demicolon.keymaps.create_default_diagnostic_keymaps.
---@field repeat_motions? boolean Create `;` and `,` key mappings

---@class DemicolonOptions
---@field diagnostic? DemicolonDiagnosticOptions Diagnostic options
---@field keymaps? DemicolonKeymapsOptions Create default keymaps
local options = {
  diagnostic = {
    float = {}
  },
  keymaps = {
    horizontal_motions = true,
    diagnostic_motions = true,
    repeat_motions = true,
  },
}

---@return DemicolonOptions
function M.get_options()
  return options
end

---@param opts DemicolonOptions
function M.setup(opts)
  options = vim.tbl_deep_extend('force', options, opts or {})

  if options.keymaps.horizontal_motions then
    keymaps.create_default_horizontal_keymaps()
  end

  if options.keymaps.repeat_motions then
    keymaps.create_default_repeat_keymaps()
  end

  if options.keymaps.diagnostic_motions then
    keymaps.create_default_diagnostic_keymaps()
  end
end

M.diagnostic_jump = jump.diagnostic_jump_repeatably

return M
