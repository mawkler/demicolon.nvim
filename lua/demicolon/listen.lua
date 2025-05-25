local M = {}

---@param previous_key string
---@return boolean
local function is_native_repeatable_motion(previous_key)
  -- Motion is split into two and starts with `]` or `[`
  return vim.tbl_contains({ ']', '[' }, previous_key)
end

---@param forward boolean
---@param motion string
---@return string
local function motion_from_direction(forward, motion)
  local prefix = motion:sub(1, 1) -- `]` or `[`
  assert(prefix == ']' or '[', 'demicolon.nvim: motion does not start with ] or [')
  local key = motion:sub(2)       -- The rest of the motion

  -- This deals with the special cases where the second character is a
  -- delimiter, which behave opposite to all other bracket motions
  local opposite_delimiters = {
    ['['] = ']',
    [']'] = '[',
    ['('] = ')',
    [')'] = '(',
    ['{'] = '}',
    ['}'] = '{',
  }

  local new_prefix = forward and ']' or '['
  local new_key = new_prefix ~= prefix
      and opposite_delimiters[key]
      -- Fallback
      or key

  return new_prefix .. new_key
end

---@param string string
local function has_bracket_prefix(string)
  if #string <= 1 then
    return false
  end

  local prefix = string:sub(1, 1)
  return prefix == ']' or prefix == '['
end

---@param disabled_keys table<string>
function M.listen_for_repetable_bracket_motions(disabled_keys)
  local previous_key

  vim.on_key(function(_, typed)
    -- `keytrans` deals with modifier cases like `]CTRL-Q` for instance
    typed = vim.fn.keytrans(typed)

    local motion

    -- For native (non-remapped) commands, `typed` will be split into two
    -- characters. That's what `previous_key` is for. For commands that have
    -- been remapped `vim.on_key` will only get called once for the entire
    -- command, and `typed` will be the entire command.
    if is_native_repeatable_motion(previous_key) then
      motion = previous_key .. typed
    elseif has_bracket_prefix(typed) then
      motion = typed
    else
      -- Not a recognized repeatable command
      previous_key = typed
      return
    end

    -- If the key is disabled
    if vim.tbl_contains(disabled_keys, motion:sub(2)) then
      return
    end

    if motion then
      local ok, ts_repeatable_move = pcall(require, 'nvim-treesitter-textobjects.repeatable_move')
      if not ok then
        ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')
      end
      ts_repeatable_move.last_move = {
        func = function(opts)
          local new_motion = motion_from_direction(opts.forward, motion)
          local keys = vim.api.nvim_replace_termcodes(new_motion, true, false, true)
          vim.api.nvim_feedkeys(keys, 'x', true)
        end,
        opts = {},
        additional_args = {},
      }
    end

    previous_key = nil -- Reset previous key on recognized command
  end)
end

return M
