local keymaps = require('demicolon.keymaps')

local M = {}

---@class demicolon.diagnostic.options
---@field float? boolean|vim.diagnostic.Opts.Float Default options passed to diagnostic floating window

---@class demicolon.keymaps.options
---@field horizontal_motions? boolean Create `t`/`T`/`f`/`F` key mappings
---@field repeat_motions? boolean Create `;` and `,` key mappings
---@field custom_keys? table<string> Keys for custom motion keys, not including the `]` prefix. I.e. if you want to add repeat support for the motion `]R`, add `'R'` to `custom_keys`
---@field native_keys? table<string> | false Native keys, many of them listed under `:help ]`. Set to `false` to disable

---@class demicolon.options
---@field diagnostic? demicolon.diagnostic.options Diagnostic options
---@field keymaps? demicolon.keymaps.options Create default keymaps
local options = {
  keymaps = {
    horizontal_motions = true,
    repeat_motions = true,
    custom_keys = {
      'R', -- Vimtex frame end
      'n', -- Vimtex math start
      'N', -- Vimtex math end
    },
    native_keys = {
      "'",
      '#',
      ')',
      '*',
      '/',
      '`',
      '[',
      ']',
      '{',
      '}',
      'A',
      'B',
      'D',
      'I',
      'L',
      'M',
      'P',
      'Q',
      'S',
      'T',
      'a',
      'b',
      'c',
      'd',
      'f',
      'i',
      'l',
      'm',
      'p',
      'q',
      'r',
      's',
      't',
      'z',
      'CTRL-L',
      'CTRL-Q',
      'CTRL-T',
    }
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

  vim.list_extend(
    options.keymaps.custom_keys,
    options.keymaps.native_keys or {}
  )

  require('demicolon.jump').listen_for_repetable_bracket_motions(options.keymaps.custom_keys)
end

return M
