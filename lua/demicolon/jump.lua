local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local M = {}

---@alias DemicolonJumpOpts { forward: boolean }

---@param keys string
local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.v.count1 .. keys, 'xn', true)
end

---@param func fun(opts: (table | DemicolonJumpOpts), additional_args?: ...) Repeatable function to be called. It should determine by the `forward` boolean whether to move forward or backward
---@param opts table | DemicolonJumpOpts Options to pass to the function. Make sure to include the `forward` boolean
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

---@param key 't' | 'T' | 'f' | 'F'
---@return fun(): string
function M.horizontal_jump(key)
  return function()
    return ts_repeatable_move['builtin_' .. key .. '_expr']()
  end
end

---@deprecated Use horizontal_jump instead
function M.horizontal_jump_repeatably(opts)
  vim.notify(
    'diagnostic.nvim: `horizontal_jump_repeatably` is deprecated. Use `horizontal_jump` instead.')
  return M.horizontal_jump(opts)
end

---@class DemicolonDiagnosticJumpOpts: vim.diagnostic.GotoOpts
---@field forward boolean

---@param opts DemicolonDiagnosticJumpOpts Note that the `count` field will be overridden by `vim.v.count1`
---@return function
function M.diagnostic_jump(opts)
  return function()
    M.repeatably_do(function(o)
      o = o or {}
      local float_opts = require('demicolon').get_options().diagnostic.float
      o.float = type(float_opts) == 'table' and vim.tbl_extend('force', o, float_opts) or float_opts

      local count = o.forward and 1 or -1
      o.count = count * vim.v.count1

      if vim.diagnostic.jump then
        vim.diagnostic.jump(o)
      else
        -- Deprecated in favor of `vim.diagnostic.jump` in Neovim 0.11.0
        if o.count > 0 then
          vim.diagnostic.goto_next(o)
        else
          vim.diagnostic.goto_prev(o)
        end
      end
    end, opts)
  end
end

---@deprecated Use `diagnostic_jump` instead
function M.diagnostic_jump_repeatably(opts)
  vim.notify(
    'diagnostic.nvim: `diagnostic_jump_repeatably` is deprecated. Use `diagnostic_jump` instead.')
  return M.diagnostic_jump(opts)
end

---@class DemicolonListJumpOpts
---@field forward boolean If `true`, jump forwards, otherwise jump backwards
---@field file? boolean  If `true`, jump by file (see `:help cnfile`/`:help lnfile`)

---@param type 'quickfix' | 'location'
---@param opts DemicolonListJumpOpts
local function list_jump(type, list, opts)
  require('demicolon.jump').repeatably_do(function(o)
    if vim.tbl_isempty(list) then
      return
    end

    local direction = o.forward and 'n' or 'p'
    local prefix = type == 'quickfix' and 'c' or 'l'
    local file_suffix = opts.file and 'f' or ''
    local command = prefix .. direction .. file_suffix

    -- Special case for `:help :lne` which is inconsistently named
    if command == 'ln' then
      command = 'lne'
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, vim.v.count1 .. command)
  end, { forward = opts.forward }, opts)
end

---@param opts DemicolonListJumpOpts
---@return function
function M.quickfix_list_jump(opts)
  return function()
    local list = vim.fn.getqflist()
    return list_jump('quickfix', list, opts)
  end
end

---@param opts DemicolonJumpOpts
---@return function
function M.location_list_jump(opts)
  return function()
    local list = vim.fn.getloclist(0)
    return list_jump('location', list, opts)
  end
end

---@param opts DemicolonJumpOpts
---@return function
function M.fold_jump(opts)
  return function()
    require('demicolon.jump').repeatably_do(function(o)
      local direction = o.forward and 'j' or 'k'
      feedkeys('z' .. direction)
    end, { forward = opts.forward }, opts)
  end
end

---@param opts DemicolonJumpOpts
---@return function
function M.spell_jump(opts)
  return function()
    require('demicolon.jump').repeatably_do(function(o)
      -- `]s`/`[s` only work if `spell` is enabled
      local spell = vim.wo.spell
      vim.wo.spell = true

      local direction = o.forward and ']' or '['
      feedkeys(direction .. 's')

      vim.wo.spell = spell
    end, { forward = opts.forward }, opts)
  end
end

return M
