local M = {}

---@param previous_key string
---@return boolean
local function is_native_repeatable_motion(previous_key)
  -- Motion is split into two and starts with `]` or `[`
  return previous_key == ']' or previous_key == '['
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

--- Run `motion` like it was typed
---@param motion string
local function run_motion(motion)
  -- Call a Lua mapping directly instead of feeding its keys, like Neovim does
  -- when the keys are typed. That way the mapping gets the count given to
  -- `;`/`,`, and works as the motion of a pending operator, like in `d;`
  local mode = vim.api.nvim_get_mode().mode
  local map_mode = mode:sub(1, 2) == 'no' and 'o' or mode:match('^[vV\22]') and 'x' or 'n'
  local mapping = vim.fn.maparg(motion, map_mode, false, true)
  if mapping.callback and mapping.expr == 0 then
    mapping.callback()
    return
  end

  local keys = vim.api.nvim_replace_termcodes(motion, true, false, true)
  vim.api.nvim_feedkeys(keys, 'x', true)
end

---@param disabled_keys table<string>
function M.listen_for_repeatable_bracket_motions(disabled_keys)
  local previous_key

  vim.on_key(function(_, typed)
    -- `keytrans` deals with modifier cases like `]CTRL-Q` for instance
    typed = vim.fn.keytrans(typed)

    local motion

    -- For native (non-remapped) commands, `typed` will be split into two
    -- characters. That's what `previous_key` is for. For commands that have
    -- been remapped `vim.on_key` will only get called once for the entire
    -- command, and `typed` will be the entire command.
    if is_native_repeatable_motion(previous_key) and vim.fn.mode() == 'no' then
      motion = previous_key .. typed
    elseif has_bracket_prefix(typed) then
      motion = typed
    elseif typed == '[' or typed == ']' then
      previous_key = typed
      return
    else
      -- Not a recognized repeatable command
      previous_key = nil
      return
    end

    -- If the key is disabled
    if vim.tbl_contains(disabled_keys, motion:sub(2)) then
      return
    end

    if motion then
      local opts = { forward = motion:sub(1, 1) == ']' }

      require('demicolon.repeatability').set_last_move(function(o)
        run_motion(motion_from_direction(o.forward, motion))
      end, opts)
    end

    previous_key = nil -- Reset previous key on recognized command
  end)
end

return M
