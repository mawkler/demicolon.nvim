local M = {}

---@param options { forward?: boolean, vimtex_key: string }
function M.jump(options)
  return function()
    require('demicolon.jump').repeatably_do(function(opts)
      if vim.fn.exists(':VimtexCompile') ~= 2 then
        vim.notify('demicolon.nvim: vimtex is not installed', vim.log.levels.WARN)
        return
      end

      local direction = (opts.forward == nil or opts.forward) and 'next' or 'prev'

      local vimtex_key = opts.vimtex_key
      local vimtex_mapping = ""

      if direction == "prev" then
        vimtex_mapping = "[" .. vimtex_key
      else
        vimtex_mapping = "]" .. vimtex_key
      end

      -- Vimtex does not use lua to map to their functions, but special <Plug>
      -- mappings, which we have to map to.
      -- All mappings of the desired type are listed here:
      -- https://github.com/lervag/vimtex/blob/83e331dcad5ce28012e656eea3906b5b897db2ba/doc/vimtex.txt#L3899

      -- Manually store the count and prepend it to the mapping to preserve it
      local count = vim.v.count
      local count_str = count > 1 and tostring(count) or ""
      local mapping = count_str .. "<Plug>(vimtex-" .. vimtex_mapping .. ")"
      local plug_mapping = vim.api.nvim_replace_termcodes(mapping, true, false, true)
      vim.api.nvim_feedkeys(plug_mapping, "m", false)
    end, options)
  end
end

---@param key string the key to map this to
---@param vimtex_mapping string the original vimtex mapping
---@param desc string the description of the mapping
function M.vimtex_map(key, vimtex_mapping, desc)
  -- Override only if it's a vimtex mapping or not set.
  -- That's roughly the behavior of vimtex as well:
  -- https://github.com/lervag/vimtex/blob/83e331dcad5ce28012e656eea3906b5b897db2ba/autoload/vimtex.vim#L415
  local existing_lhs = vim.fn.maparg(vimtex_mapping, "nxo")
  if (existing_lhs ~= '' and existing_lhs:sub(1, 13) ~= "<Plug>(vimtex") then
    return
  end

  local vimtex_key = vimtex_mapping:sub(2, 2)
  local forward = vimtex_mapping:sub(1, 1) == "]"

  local nxo = { 'n', 'x', 'o' }

  vim.keymap.set(nxo, key, M.jump({ forward = forward, vimtex_key = vimtex_key }), { desc = desc, buffer = true })
end

function M.create_keymaps()
  local options = require('demicolon').get_options().integrations.vimtex
  local keymaps = options and options.keymaps

  if not options or not options.enabled or not keymaps then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup('demicolon_vimtex_keymap', {}),
    pattern = "tex",
    callback = function()
      M.vimtex_map(keymaps.section_begin.next, "][", "Next section begin")
      M.vimtex_map(keymaps.section_begin.prev, "[[", "Previous section begin")

      M.vimtex_map(keymaps.section_end.next, "]]", "Next section end")
      M.vimtex_map(keymaps.section_end.prev, "[]", "Previous section end")

      M.vimtex_map(keymaps.frame_start.next, "]r", "Next frame start")
      M.vimtex_map(keymaps.frame_start.prev, "[r", "Previous frame start")

      M.vimtex_map(keymaps.frame_end.next, "]R", "Next frame end")
      M.vimtex_map(keymaps.frame_end.prev, "[R", "Previous frame end")

      M.vimtex_map(keymaps.math_start.next, "]n", "Next math start")
      M.vimtex_map(keymaps.math_start.prev, "[n", "Previous math start")

      M.vimtex_map(keymaps.math_end.next, "]N", "Next math end")
      M.vimtex_map(keymaps.math_end.prev, "[N", "Previous math end")

      M.vimtex_map(keymaps.comment_start.next, "]/", "Next comment start")
      M.vimtex_map(keymaps.comment_start.prev, "[/", "Previous comment start")

      M.vimtex_map(keymaps.comment_end.next, "]%", "Next comment end")
      M.vimtex_map(keymaps.comment_end.prev, "[%", "Previous comment end")

      M.vimtex_map(keymaps.environment_start.next, "]m", "Next environment start")
      M.vimtex_map(keymaps.environment_start.prev, "[m", "Previous environment start")

      M.vimtex_map(keymaps.environment_end.next, "]M", "Next environment end")
      M.vimtex_map(keymaps.environment_end.prev, "[M", "Previous environment end")
    end,
  })
end

return M
