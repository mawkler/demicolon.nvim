local M = {}

local nxo = { 'n', 'x', 'o' }

---@param repeat_behaviour 'stateless' | 'stateful'
function M.create_default_repeat_keymaps(repeat_behaviour)
  local is_valid_behaviour_type = type(repeat_behaviour) == 'string'
    and (repeat_behaviour == 'stateless' or repeat_behaviour == 'stateful')
  assert(is_valid_behaviour_type, 'demicolon.nvim: keymaps.repeat_motions must either be \'stateless\' or \'stateful\'')

  local repeat_jump = require('demicolon.repeat_jump')

  if repeat_behaviour == 'stateless' then
    vim.keymap.set(nxo, ';', repeat_jump.forward)
    vim.keymap.set(nxo, ',', repeat_jump.backward)
  else
    vim.keymap.set(nxo, ';', repeat_jump.next)
    vim.keymap.set(nxo, ',', repeat_jump.prev)
  end
end

---@param cfg demicolon.alternative_repeat.options
function M.create_alternative_repeat_keymaps(cfg)
  local repeat_jump = require('demicolon.repeat_jump')
  local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

  local function has_motion()
    return ts_repeatable_move.last_move ~= nil
  end

  ---@param spec demicolon.alternative_repeat.spec
  local function register(spec, dir_fn, description)
    if not spec or not spec.key or spec.key == '' then
      return
    end

    local raw_keys = type(spec.key) == 'table' and spec.key or { spec.key }
    ---@cast raw_keys string[]

    for _, lhs in ipairs(raw_keys) do
      vim.keymap.set('n', lhs, function()
        if has_motion() then
          dir_fn()
        else
          local feed = vim.api.nvim_replace_termcodes(spec.fallback or lhs, true, false, true)
          vim.api.nvim_feedkeys(feed, 'ni', false)
        end
      end, {
        desc = description,
        noremap = true,
      })
    end
  end

  register(cfg.forward, repeat_jump.next, 'demicolon alt-repeat forward')
  register(cfg.backward, repeat_jump.prev, 'demicolon alt-repeat backward')
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
