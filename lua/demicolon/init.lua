local keymaps = require('demicolon.keymaps')
local jump = require('demicolon.jump')

local M = {}

---@class DemicolonDiagnosticOptions
---@field float? vim.diagnostic.Opts.Float Default options passed to diagnostic floating window

---@class DemicolonKeymapsOptions
---@field horizontal_motions? boolean Create `t`/`T`/`f`/`F` key mappings
---@field diagnostic_motions? boolean Create ]d/[d, etc. key mappings to jump to diganostics. See demicolon.keymaps.create_default_diagnostic_keymaps.
---@field repeat_motions? boolean Create `;` and `,` key mappings
---@field list_motions? boolean Create `]q`/`[q` and `]l`/`[l` quickfix and location list mappings
---@field spell_motions? boolean Create `]s`/`[s` key mappings for jumping to spelling mistakes
---@field fold_motions? boolean Create `]z`/`[z` key mappings for jumping to folds

---@class DemicolonGitsignsKeymapOptions
---@field next? string
---@field prev? string

---@class DemicolonGitsignsOptions
---@field enabled? boolean
---@field keymaps? DemicolonGitsignsKeymapOptions

---@class DemicolonIntegrationOptions
---@field gitsigns? DemicolonGitsignsOptions Integration with https://github.com/lewis6991/gitsigns.nvim

---@class DemicolonOptions
---@field diagnostic? DemicolonDiagnosticOptions Diagnostic options
---@field keymaps? DemicolonKeymapsOptions Create default keymaps
---@field integrations? DemicolonIntegrationOptions Integrations with other plugins
local options = {
  diagnostic = {
    float = {},
  },
  keymaps = {
    horizontal_motions = true,
    diagnostic_motions = true,
    repeat_motions = true,
    list_motions = true,
    spell_motions = true,
    fold_motions = true,
  },
  integrations = {
    gitsigns = {
      enabled = true,
      keymaps = {
        next = ']c',
        prev = '[c',
      },
    },
  },
}

---@return DemicolonOptions
function M.get_options()
  return options
end

---@param opts? DemicolonOptions
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

  if options.keymaps.list_motions then
    keymaps.create_default_list_keymaps()
  end

  if options.keymaps.spell_motions then
    keymaps.create_default_spell_keymaps()
  end

  if options.keymaps.fold_motions then
    keymaps.create_default_fold_keymaps()
  end

  if options.integrations.gitsigns.enabled then
    require('demicolon.integrations.gitsigns').create_keymaps()
  end
end

return M
