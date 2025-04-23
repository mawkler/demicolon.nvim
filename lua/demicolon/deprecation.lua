local M = {}

local function warn(message)
  vim.notify(('demicolon.nvim: %s'):format(message), vim.log.levels.WARN)
end

---@param options demicolon.options
function M.warn_for_deprecated_options(options)
  if options.integrations then
    local message =
    "'integrations' option has been deprecated. Most plugins should work out of the box now. For custom keymaps see the new 'keymaps.custom_keys' option."
    warn(message)
  end
end

return M
