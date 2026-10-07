local repeatability = require('demicolon.repeatability')

local M = {}

--- Repeat the last last demicolon jump forward
function M.forward()
  return repeatability.repeat_last_move({ forward = true, repeated = true })
end

--- Repeat the last last demicolon jump backward
function M.backward()
  return repeatability.repeat_last_move({ forward = false, repeated = true })
end

--- Like `forward`, but repeats based on the direction of the original jump.
function M.next()
  return repeatability.repeat_last_move({ repeated = true })
end

--- Like `backward`, but repeats based on the direction of the original jump.
function M.prev()
  local opts = { repeated = true }
  if repeatability.last_move then
    opts.forward = not repeatability.last_move.opts.forward
  end
  return repeatability.repeat_last_move(opts)
end

return M
