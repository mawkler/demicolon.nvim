# demicolon.nvim

Demicolon lets you repeat **all** `]`/`[`-prefixed motions with `;` (repeat forward). For example `]q`, `]l`, `]s` and `]]`, as well as motions defined by [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move).

See [**Usage**](#usage) and [**Configuration**](#configuration) for more information.

> [!NOTE]
> Because of Demicolon's 2.0 reimplementation that now automagically lets you repeat **all** `]` and `[` prefixed motions, demicolon no longer creates plugin-specific (or diagnostics) keymaps. If you depended on Demicolon's default plugin keymaps, here is what's been removed:

<details>
<summary><b>Click to expand</b></summary>

```lua
-- Diagnostics
local function diagnostic_jump(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, severity = severity })
  end
end

local map, nxo = vim.keymap.set, { 'n', 'x', 'o' }
local severity = vim.diagnostic.severity
local error, warn, info, hint = severity.ERROR, severity.WARN, severity.INFO, severity.HINT

map(nxo, ']e', diagnostic_jump(1, error), { desc = 'Next error' })
map(nxo, '[e', diagnostic_jump(-1, error), { desc = 'Previous error' })

map(nxo, ']w', diagnostic_jump(1, warn), { desc = 'Next warning' })
map(nxo, '[w', diagnostic_jump(-1, warn), { desc = 'Previous warning' })

map(nxo, ']i', diagnostic_jump(1, info), { desc = 'Next info' })
map(nxo, '[i', diagnostic_jump(1, info), { desc = 'Previous info' })

map(nxo, ']h', diagnostic_jump(1, hint), { desc = 'Next hint' })
map(nxo, '[h', diagnostic_jump(-1, hint), { desc = 'Previous hint' })

-- Gitsigns (from its README):
local map = vim.keymap.set
map('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  else
    gitsigns.nav_hunk('next')
  end
end)

map('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
  else
    gitsigns.nav_hunk('prev')
  end
end)

-- Neotest
local map, nxo = vim.keymap.set, { 'n', 'x', 'o' }

local function neotest_jump(direction, status)
  return function()
    require('neotest').jump[direction]({ status = status })
  end
end

map(nxo, ']t', neotest_jump('next'), { desc = 'Next test' })
map(nxo, '[t', neotest_jump('prev'), { desc = 'Previous test' })
map(nxo, ']T', neotest_jump('next', 'failed'), { desc = 'Next failed test' })
map(nxo, '[T', neotest_jump('prev', 'failed'), { desc = 'Previous failed test' })
```

</details>

https://github.com/user-attachments/assets/e847cf39-40bd-49cb-9989-34e921b3393a

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'mawkler/demicolon.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {}
}
```

## Usage

After pressing a `]`/`[`-prefixed key, for example `]q`, Demicolon lets you repeat its motion with `;` and `,`.

Of course, Demicolon also lets you repeat `t`/`T`/`f`/`F` with `;`/`,`. See [`:help t`](https://neovim.io/doc/user/motion.html#t), [`:help T`](https://neovim.io/doc/user/motion.html#T), [`:help f`](https://neovim.io/doc/user/motion.html#f), and [`:help F`](https://neovim.io/doc/user/motion.html#F) respectively for more information.

### Examples of repeatable motions

Below are some examples of motions, both built-in and provided by plugins.

#### Native Neovim motions

| Motion            | Jumps to next/pevious...                | Help page with more information                                                                                                             |
| ----------------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `]d`/`[d`         | Next/previous diagnostic (any severity) | [`:help ]d`](https://neovim.io/doc/user/tagsrch.html#%5Dd-default)/[`:help [d`](https://neovim.io/doc/user/tagsrch.html#%5Bd-default)       |
| `]q`/`[q`         | Item in quickfix list                   | [`:help ]q`](https://neovim.io/doc/user/quickfix.html#%5Dq)/[`:help [q`](https://neovim.io/doc/user/quickfix.html#%5Bq)                     |
| `]l`/`[l`         | Item in location list                   | [`:help ]l`](https://neovim.io/doc/user/quickfix.html#%5Dl)/[`:help [l`](https://neovim.io/doc/user/quickfix.html#%5Bl)                     |
| `]<C-q>`/`[<C-q>` | File in quickfix list                   | [`:help ]CTRL-Q`](https://neovim.io/doc/user/quickfix.html#%5DCTRL-Q)/[`:help [CTRL-Q`](https://neovim.io/doc/user/quickfix.html#%5BCTRL-Q) |
| `]<C-l>`/`[<C-l>` | File in location list                   | [`:help ]CTRL-L`](https://neovim.io/doc/user/quickfix.html#%5DCTRL-L)/[`:help [CTRL-L`](https://neovim.io/doc/user/quickfix.html#%5BCTRL-L) |
| `]z`/`[z`         | Fold                                    | [`:help z]`](https://neovim.io/doc/user/fold.html#%5Dz)/[`:help z[`](https://neovim.io/doc/user/fold.html#%5Bz)                                 |
| `]s`/`[s`         | Spelling mistake                        | [`:help ]s`](https://neovim.io/doc/user/spell.html#%5Ds)/[`:help [s`](https://neovim.io/doc/user/spell.html#%5Bs)                           |

For a list of more native motions see [`:help ]`](https://neovim.io/doc/user/vimindex.html#%5D)

#### [Nvim-treesitter-textobject](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move) motions

Demicolon lets you repeat any [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move) motion. For example: `]f` to "jump to next function", `]c` to "jump to next class", etc.

> [!NOTE]
> To use treesitter text-objects you need to [configure `textobjects.move` in nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move).

#### [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) motions

| Motion    | Jumps to next/pevious... | Help page with more information |
| --------- | ------------------------ | ------------------------------- |
| `]c`/`[c` | Git hunk                 | `:help gitsigns.nav_hunk()`     |

#### [Neotest](https://github.com/nvim-neotest/neotest) motions

| Motion    | Jumps to next/pevious... | Help page with more information |
| --------- | ------------------------ | ------------------------------- |
| `]t`/`[t` | Test                     | `:help neotest.jump`            |
| `]T`/`[T` | Failed test              | `:help neotest.jump`            |

#### [VimTeX](https://github.com/lervag/vimtex) motions

Note that these mappings are only created in normal mode and visual mode. For some reason they don't work when created for operator-pending mode.

| Motion    | Jumps to next/pevious... | Help page with more information |
| --------- | ------------------------ | ------------------------------- |
| `]]`/`[[` | Section start            | `:help vimtex-motions`          |
| `][`/`[]` | Section end              | `:help vimtex-motions`          |
| `]r`/`[r` | Frame start              | `:help vimtex-motions`          |
| `]R`/`[R` | Frame end                | `:help vimtex-motions`          |
| `]n`/`[n` | Math start               | `:help vimtex-motions`          |
| `]N`/`[N` | Math end                 | `:help vimtex-motions`          |
| `]/`/`[/` | Comment start            | `:help vimtex-motions`          |
| `]*`/`[*` | Comment end              | `:help vimtex-motions`          |
| `]m`/`[m` | Environment start        | `:help vimtex-motions`          |
| `]M`/`[M` | Environment end          | `:help vimtex-motions`          |

## Configuration

Default options:

```lua
opts = {
  -- Create default keymaps
  keymaps = {
    -- Create t/T/f/F key mappings
    horizontal_motions = true,
    -- Create ; and , key mappings. Set it to 'stateless', 'stateful', or false to
    -- not create any mappings. 'stateless' means that ;/, move right/left.
    -- 'stateful' means that ;/, will remember the direction of the original
    -- jump, and `,` inverts that direction (Neovim's default behaviour).
    repeat_motions = 'stateless',
    -- Keys that shouldn't be repeatable (because aren't motions), excluding the prefix `]`/`[`
    -- If you have custom motions that use one of these, make sure to remove that key from here
    disabled_keys = { 'p', 'I', 'A', 'f', 'i' },
  },
}
```

### Use different repeat keys

If you’d rather not use `;` and `,` disable Demicolon’s default repeat mappings and bind your own:

```lua
require('demicolon').setup({
  keymaps = {
    repeat_motions = false, -- don't create ; and ,
  },
})

local map, nxo = vim.keymap.set, { 'n', 'x', 'o' }

-- Stateless: always forward/backward
map(nxo, 'n', require('demicolon.repeat_jump').forward)
map(nxo, 'N', require('demicolon.repeat_jump').backward)

-- Or, stateful (remember the original motion’s direction)
-- map(nxo, 'n', require('demicolon.repeat_jump').next)
-- map(nxo, 'N', require('demicolon.repeat_jump').prev)

```

**NOTE:** You can bind any keys (e.g. arrows or <leader> combos) the same way.

### Custom jumps

If you have custom motions that don't start with `]`/`[` that you want to make repetable ([for example for flash.nvim](https://github.com/mawkler/demicolon.nvim/issues/11)) you can create your own custom repeatable jumps using `repeatably_do()` in [`demicolon.jump`](./lua/demicolon/jump.lua). `repeatably_do()` takes a funcion as its first argument and options to be passed to that function as its second argument. Make sure that the options include a boolean `forward` field to determine whether the action should be forward or backward. Take a look at how I've implemented the [neotest integration](./lua/demicolon/integrations/neotest.lua#L4-L17) for inspiration.

### eyeliner.nvim integration

[eyeliner.nvim](https://github.com/jinh0/eyeliner.nvim) can highlight unique letters in words when you press `t`/`T`/`f`/`F`. Below is my recommended configuration for using eyeliner.nvim together with Demicolon.

**NOTE:** make sure to set `keymaps.horizontal_motions = false` in your demicolon setup if you want to use this config.

```lua
return {
  'jinh0/eyeliner.nvim',
  -- keys = { 't', 'f', 'T', 'F' }, -- Uncomment this to lazy load eyeliner.nvim
  config = function()
    require('eyeliner').setup({
      highlight_on_key = true,
      default_keymaps = false,
      dim = true, -- Optional
    })

    local function eyeliner_jump(key)
      local forward = vim.list_contains({ 't', 'f' }, key)
      return function()
        require('eyeliner').highlight({ forward = forward })
        return require('demicolon.jump').horizontal_jump(key)()
      end
    end

    local nxo = { 'n', 'x', 'o' }
    local opts = { expr = true }

    vim.keymap.set(nxo, 'f', eyeliner_jump('f'), opts)
    vim.keymap.set(nxo, 'F', eyeliner_jump('F'), opts)
    vim.keymap.set(nxo, 't', eyeliner_jump('t'), opts)
    vim.keymap.set(nxo, 'T', eyeliner_jump('T'), opts)
  end,
}
```

### Full recommended config

Here is a full configuration, including [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) and [eyeliner.nvim](https://github.com/jinh0/eyeliner.nvim):

<details>
<summary><b>Click here to see the code</b></summary>

```lua
require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              [']f'] = '@function.outer',
              [']a'] = '@argument.outer',
              [']m'] = '@method.outer',
              -- ...
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[a'] = '@argument.outer',
              ['[m'] = '@method.outer',
              -- ...
            },
          },
        },
      })
    end,
  },
  {
    'jinh0/eyeliner.nvim',
    keys = { 't', 'f', 'T', 'F' },
    config = function()
      require('eyeliner').setup({
        highlight_on_key = true,
        dim = true,
        default_keymaps = false,
      })

      local function eyeliner_jump(key)
        local forward = vim.list_contains({ 't', 'f' }, key)
        return function()
          require('eyeliner').highlight({ forward = forward })
          return require('demicolon.jump').horizontal_jump(key)()
        end
      end

      local map, nxo, opts = vim.keymap.set, { 'n', 'x', 'o' }, { expr = true }

      map(nxo, 'f', eyeliner_jump('f'), opts)
      map(nxo, 'F', eyeliner_jump('F'), opts)
      map(nxo, 't', eyeliner_jump('t'), opts)
      map(nxo, 'T', eyeliner_jump('T'), opts)
    end,
  },
  {
    'mawkler/demicolon.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      keymaps = {
        horizontal_motions = false,
        -- `f` is removed from this table because we have mapped it to
        -- `@function.outer` with nvim-treesitter-textobjects
        disabled_keys = { 'p', 'I', 'A', 'i' },
      },
    },
  },
})
```

</details>

[Here's](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects) the full list of available treesitter textobjects.

## Credit

[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) is used at the core of Demicolon's repeat logic. Credit to them for making an awesome plugin!
