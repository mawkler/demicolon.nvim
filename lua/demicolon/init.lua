local keymaps = require('demicolon.keymaps')

local M = {}

---@class DemicolonDiagnosticOptions
---@field float? boolean|vim.diagnostic.Opts.Float Default options passed to diagnostic floating window

---@class DemicolonKeymapsOptions
---@field horizontal_motions? boolean Create `t`/`T`/`f`/`F` key mappings
---@field diagnostic_motions? boolean Create ]d/[d, etc. key mappings to jump to diganostics. See demicolon.keymaps.create_default_diagnostic_keymaps.
---@field repeat_motions? boolean Create `;` and `,` key mappings
---@field list_motions? boolean Create `]q`/`[q`/`]<C-q>`/`[<C-q>` and `]l`/`[l`/`]<C-l>`/`[<C-l>` quickfix and location list mappings
---@field spell_motions? boolean Create `]s`/`[s` key mappings for jumping to spelling mistakes
---@field fold_motions? boolean Create `]z`/`[z` key mappings for jumping to folds

---@class DemicolonIntegrationKeymaps
---@field next? string
---@field prev? string

---@class DemicolonGitsignsOptions
---@field enabled? boolean
---@field keymaps? DemicolonIntegrationKeymaps

---@class DemicolonNeotestKeymapOptions
---@field test? DemicolonIntegrationKeymaps
---@field failed_test? DemicolonIntegrationKeymaps

---@class DemicolonNeotestOptions
---@field enabled? boolean
---@field keymaps? DemicolonNeotestKeymapOptions

---@class DemicolonVimtexKeymapOptions
---@field section_begin? DemicolonIntegrationKeymaps
---@field section_end? DemicolonIntegrationKeymaps
---@field frame_start? DemicolonIntegrationKeymaps
---@field frame_end? DemicolonIntegrationKeymaps
---@field math_start? DemicolonIntegrationKeymaps
---@field math_end? DemicolonIntegrationKeymaps
---@field comment_start? DemicolonIntegrationKeymaps
---@field comment_end? DemicolonIntegrationKeymaps
---@field environment_start? DemicolonIntegrationKeymaps
---@field environment_end? DemicolonIntegrationKeymaps

---@class DemicolonVimtexOptions
---@field enabled? boolean
---@field keymaps? DemicolonVimtexKeymapOptions

---@class DemicolonIntegrationOptions
---@field gitsigns? DemicolonGitsignsOptions Integration with https://github.com/lewis6991/gitsigns.nvim
---@field neotest? DemicolonNeotestOptions Integration with https://github.com/nvim-neotest/neotest
---@field vimtex? DemicolonVimtexOptions Integration with https://github.com/lervag/vimtex

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
    neotest = {
      enabled = true,
      keymaps = {
        test = {
          next = ']t',
          prev = '[t',
        },
        failed_test = {
          next = ']T',
          prev = '[T',
        },
      },
    },
    vimtex = {
      enabled = true,
      keymaps = {
        section_begin = {
          next = '][',
          prev = '[[',
        },
        section_end = {
          next = ']]',
          prev = '[]',
        },
        frame_start = {
          next = ']r',
          prev = '[r',
        },
        frame_end = {
          next = ']R',
          prev = '[R',
        },
        math_start = {
          next = ']n',
          prev = '[n',
        },
        math_end = {
          next = ']N',
          prev = '[N',
        },
        comment_start = {
          next = ']/',
          prev = '[/',
        },
        comment_end = {
          next = ']%',
          prev = '[%',
        },
        environment_start = {
          next = ']m',
          prev = '[m',
        },
        environment_end = {
          next = ']M',
          prev = '[M',
        },
      }
    }
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

  if options.integrations.neotest.enabled then
    require('demicolon.integrations.neotest').create_keymaps()
  end

  if options.integrations.vimtex.enabled then
    require('demicolon.integrations.vimtex').create_keymaps()
  end
end

return M
