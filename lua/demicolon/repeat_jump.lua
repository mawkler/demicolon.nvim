local ok, ts_repeatable_move = pcall(require, 'nvim-treesitter-textobjects.repeatable_move')
if not ok then
  ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')
end

local M = {}

--- Repeat the last last demicolon jump forward
function M.forward()
  return ts_repeatable_move.repeat_last_move({ forward = true, repeated = true })
end

--- Repeat the last last demicolon jump backward
function M.backward()
  return ts_repeatable_move.repeat_last_move({ forward = false, repeated = true })
end

--- Like `forward`, but repeats based on the direction of the original jump.
function M.next()
  return ts_repeatable_move.repeat_last_move({ repeated = true })
end

--- Like `backward`, but repeats based on the direction of the original jump.
function M.prev()
  local opts = {
    forward = not ts_repeatable_move.last_move.opts.forward,
    repeated = true,
  }
  return ts_repeatable_move.last_move and ts_repeatable_move.repeat_last_move(opts)
end

return M
