local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

---@alias demicolon.jump.opts { forward: boolean }

---@param func fun(opts: (table | demicolon.jump.opts), additional_args?: ...) Repeatable function to be called. It should determine by the `forward` boolean whether to move forward or backward
---@param opts table | demicolon.jump.opts Options to pass to the function. Make sure to include the `forward` boolean
---@param additional_args? any[]
function M.repeatably_do(func, opts, additional_args)
  opts = opts or {}
  additional_args = additional_args or {}
  ts_repeatable_move.last_move = {
    func = func,
    opts = opts,
    additional_args = additional_args,
  }

  func(opts, unpack(additional_args))
end

---@param key string
---@param repeatable_bracket_keys table<string>
---@return boolean
local function native_repeatable_motion(previous_key, key, repeatable_bracket_keys)
  local split_trigger = vim.tbl_contains({ ']', '[' }, previous_key)
      and vim.tbl_contains(repeatable_bracket_keys, key)
  return split_trigger
end

--- NOTE: assumes that all repeatable commands are two characters long, for
--- example `]f`
---@param typed string
---@param repeatable_bracket_keys table<string>
---@return boolean
local function remapped_repeatable_motion(typed, repeatable_bracket_keys)
  return vim.tbl_contains(repeatable_bracket_keys, typed:sub(2))
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
  local prefix = string:sub(1, 1)
  return prefix == ']' or '['
end

---@param repeatable_bracket_keys table<string>
function M.listen_for_repetable_bracket_motions(repeatable_bracket_keys)
  local previous_key

  vim.on_key(function(_, typed)
    -- `keytrans` deals with modifier cases like `]CTRL-Q` for instance
    typed = vim.fn.keytrans(typed)

    -- For native (non-remapped) commands, `typed` will be split into two
    -- characters. That's what `previous_key` is for. For commands that have
    -- been remapped `vim.on_key` will only get called once for the entire
    -- command, and `typed` will be the entire command.

    local motion

    if native_repeatable_motion(previous_key, typed, repeatable_bracket_keys) then
      motion = previous_key .. typed
    elseif
        has_bracket_prefix(typed)
        and remapped_repeatable_motion(typed, repeatable_bracket_keys)
    then
      motion = typed
    else
      -- Not a recognized repeatable command
      previous_key = typed
      return
    end

    if motion then
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

---@param key 't' | 'T' | 'f' | 'F'
---@return fun(): string
function M.horizontal_jump(key)
  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

return M
