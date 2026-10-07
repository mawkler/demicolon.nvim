-- Run with `nvim --headless --clean -l tests/run.lua`
local T = dofile(vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h') .. '/init.lua')

for _, spec in ipairs(vim.fn.glob(T.root .. '/tests/*_spec.lua', false, true)) do
  T.print('\n' .. vim.fn.fnamemodify(spec, ':t'))
  dofile(spec)(T)
end

T.print(T.failures == 0 and '\nAll tests passed' or ('\n' .. T.failures .. ' test(s) failed'))
vim.cmd.cquit(T.failures)
