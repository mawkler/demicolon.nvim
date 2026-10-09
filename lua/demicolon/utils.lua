local M = {}

--- Execute `command` in normal mode with default keymaps
---@param command string
function M.normal_cmd(command)
  vim.cmd.normal({ command, bang = true })
end

return M
