local keymaps = require('demicolon.keymaps')

local M = {}

---@class demicolon.diagnostic.options
---@field float? boolean|vim.diagnostic.Opts.Float Default options passed to diagnostic floating window

---@class demicolon.keymaps.options
---@field horizontal_motions? boolean Create `t`/`T`/`f`/`F` key mappings
---@field repeat_motions? boolean Create `;` and `,` key mappings
---@field disabled_keys? table<string> Keys that shouldn't be repeatable (because aren't motions), excluding the prefix `]`/`[`

---@class demicolon.options
---@field diagnostic? demicolon.diagnostic.options Diagnostic options
---@field keymaps? demicolon.keymaps.options Create default keymaps
local options = {
  keymaps = {
    horizontal_motions = true,
    repeat_motions = true,
    disabled_keys = { 'p', 'I', 'A', 'f', 'i' },
  },
}

---@return demicolon.options
function M.get_options()
  return options
end

---@param opts? demicolon.options
function M.setup(opts)
  options = vim.tbl_deep_extend('force', options, opts or {})

  if options.keymaps.horizontal_motions then
    keymaps.create_default_horizontal_keymaps()
  end

  if options.keymaps.repeat_motions then
    keymaps.create_default_repeat_keymaps()
  end

  require('demicolon.deprecation').warn_for_deprecated_options(options)

  require('demicolon.jump').listen_for_repetable_bracket_motions(options.keymaps.disabled_keys)
end

return M
