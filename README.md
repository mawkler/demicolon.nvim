# demicolon.nvim

In addition to repeating just the `t`/`T`/`f`/`F` motions with `;` (repeat forward) and `,` (repeat backward), demicolon.nvim also lets you use them to repeat other types of motions:

- [Native Neovim motions](#native-neovim-motions) (e.g. `]q/[q`)
- [Diagnostic jumps](#diagnostic-motions) (e.g. `]d`/`[d`)
- [nvim-treesitter-textobjects](#treesitter-text-object-motions) (e.g. `]f`/`[f`)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) (`]c`/`[c`)
- [neotest](https://github.com/nvim-neotest/neotest) (e.g. `]t`/`[t`)

See [**Usage**](#usage) and [**Configuration**](#configuration) for more information.

https://github.com/user-attachments/assets/e847cf39-40bd-49cb-9989-34e921b3393a

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'mawkler/demicolon.nvim',
  -- keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' }, -- Uncomment this to lazy load
  -- ft = 'tex',                                                    -- ...and this if you use LaTeX
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {}
}
```

## Usage

After pressing any of the keymaps below, demicolon.nvim lets you repeat them with `;` and `,`.

### `t`/`T`/`f`/`F` motions

See [`:help t`](https://neovim.io/doc/user/motion.html#t), [`:help T`](https://neovim.io/doc/user/motion.html#T), [`:help f`](https://neovim.io/doc/user/motion.html#f), and [`:help F`](https://neovim.io/doc/user/motion.html#F) respectively.

### Diagnostic motions

By default, demicolon.nvim will create the diagnostic motion keymaps below. See [Configuration](#Configuration) for info on how to disable default keymaps.

| Motion    | Description                             |
| --------- | --------------------------------------- |
| `]d`/`[d` | Next/previous diagnostic (any severity) |
| `]e`/`[e` | Next/previous error                     |
| `]w`/`[w` | Next/previous warning                   |
| `]i`/`[i` | Next/previous information               |
| `]h`/`[h` | Next/previous hint                      |

### Treesitter text-object motions

demicolon.nvim lets you repeat any [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move) motion. For example: `]f` to "jump to next function", `]c` to "jump to next class", etc.

> [!NOTE]
> To use treesitter text-objects you need to [configure `textobjects.move` in nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move).

### Native Neovim motions

| Motion            | Jumps to next/pevious... | Help page with more information                                                                                                             |
| ----------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `]q`/`[q`         | item in quickfix list    | [`:help ]q`](https://neovim.io/doc/user/quickfix.html#%5Dq)/[`:help [q`](https://neovim.io/doc/user/quickfix.html#%5Bq)                     |
| `]l`/`[l`         | item in location list    | [`:help ]l`](https://neovim.io/doc/user/quickfix.html#%5Dl)/[`:help [l`](https://neovim.io/doc/user/quickfix.html#%5Bl)                     |
| `]<C-q>`/`[<C-q>` | file in quickfix list    | [`:help ]CTRL-Q`](https://neovim.io/doc/user/quickfix.html#%5DCTRL-Q)/[`:help [CTRL-Q`](https://neovim.io/doc/user/quickfix.html#%5BCTRL-Q) |
| `]<C-l>`/`[<C-l>` | file in location list    | [`:help ]CTRL-L`](https://neovim.io/doc/user/quickfix.html#%5DCTRL-L)/[`:help [CTRL-L`](https://neovim.io/doc/user/quickfix.html#%5BCTRL-L) |
| `]z`/`[z`         | fold                     | [`:help zj`](https://neovim.io/doc/user/fold.html#zj)/[`:help zk`](https://neovim.io/doc/user/fold.html#zk)                                 |
| `]s`/`[s`         | spelling mistake         | [`:help ]s`](https://neovim.io/doc/user/spell.html#%5Ds)/[`:help [s`](https://neovim.io/doc/user/spell.html#%5Bs)                           |

### [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) motions

| Motion    | Jumps to next/pevious... | Help page with more information |
| --------- | ------------------------ | ------------------------------- |
| `]c`/`[c` | Git hunk                 | `:help gitsigns.nav_hunk()`     |

### [Neotest](https://github.com/nvim-neotest/neotest) motions

| Motion    | Jumps to next/pevious... | Help page with more information |
| --------- | ------------------------ | ------------------------------- |
| `]t`/`[t` | Test                     | `:help neotest.jump`            |
| `]T`/`[T` | Failed test              | `:help neotest.jump`            |

### [VimTeX](https://github.com/lervag/vimtex) motions

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
  diagnostic = {
    -- See `:help vim.diagnostic.Opts.Float`
    float = {}
  },
  -- Create default keymaps
  keymaps = {
    -- Create t/T/f/F key mappings
    horizontal_motions = true,
    -- Create ]d/[d, etc. key mappings to jump to diganostics. See demicolon.keymaps.create_default_diagnostic_keymaps
    diagnostic_motions = true,
    -- Create ; and , key mappings
    repeat_motions = true,
    -- Create ]q/[q/]<C-q>/[<C-q> and ]l/[l/]<C-l>/[<C-l> quickfix and location list mappings
    list_motions = true,
    -- Create `]s`/`[s` key mappings for jumping to spelling mistakes
    spell_motions = true,
    -- Create `]z`/`[z` key mappings for jumping to folds
    fold_motions = true,
  },
  integrations = {
    -- Integration with https://github.com/lewis6991/gitsigns.nvim
    gitsigns = {
      enabled = true,
      keymaps = {
        next = ']c',
        prev = '[c',
      },
    },
    -- Integration with https://github.com/nvim-neotest/neotest
    neotest = {
      enabled = true,
      keymaps = {
        test = {
          next = ']t',
          prev = '[t',
        },
        failed_test = {
          next = ']T',
          prev = '[T',
        },
      },
    },
    -- Integration with https://github.com/lervag/vimtex
    vimtex = {
      enabled = true,
      keymaps = {
        section_start = {
          next = ']]',
          prev = '[[',
        },
        section_end = {
          next = '][',
          prev = '[]',
        },
        frame_start = {
          next = ']r',
          prev = '[r',
        },
        frame_end = {
          next = ']R',
          prev = '[R',
        },
        math_start = {
          next = ']n',
          prev = '[n',
        },
        math_end = {
          next = ']N',
          prev = '[N',
        },
        comment_start = {
          next = ']/',
          prev = '[/',
        },
        comment_end = {
          next = ']*',
          prev = '[*',
        },
        environment_start = {
          next = ']m',
          prev = '[m',
        },
        environment_end = {
          next = ']M',
          prev = '[M',
        },
      }
    },
  },
}
```

### Custom jumps

You can create your own custom repeatable jumps using `repeatably_do()` in [`demicolon.jump`](./lua/demicolon/jump.lua). `repeatably_do()` takes a funcion as its first argument and options to be passed to that function as its second argument. Make sure that the options include a boolean `forward` field to determine whether the action should be forward or backward. Take a look at how I've implemented the [neotest integration](./lua/demicolon/integrations/neotest.lua#L4-L17) for inspiration.

### eyeliner.nvim integration

[eyeliner.nvim](https://github.com/jinh0/eyeliner.nvim) can highlight unique letters in words when you press `t`/`T`/`f`/`F`. Below is my recommended configuration for using eyeliner.nvim together with demicolon.nvim.

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
  end
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
    opts = {
      highlight_on_key = true,
      dim = true,
      default_keymaps = false,
    }
  },
  {
    'mawkler/demicolon.nvim',
    dependencies = {
      'jinh0/eyeliner.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects'
    },
    keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' },
    config = function()
      require('demicolon').setup({
        keymaps = {
          horizontal_motions = false,
        },
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
    end
  }
})
```

</details>

[Here's](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects) the full list of available treesitter textobjects.

### "I want `;`/`,` to remember the direction of the original jump"

Neovim's default behaviour is for `;`/`,` to remember the direction of the jump that they repeat. That means that if you for instance repeat a `T` motion (as opposed to `t`) with `;` it will move you to the _left_. A lot of people prefer if `;` always moves you to the right and `,` always to the left, which is how demicolon works by default.

If you prefer Neovim's default behaviour you can disable demicolon's default `;`/`,` keymaps and remap them manually like this:

<details>
<summary><b>Click here to see the code</b></summary>

```lua
require('demicolon').setup({
  keymaps = {
    repeat_motions = false,
  },
})

local nxo = { 'n', 'x', 'o' }

vim.keymap.set(nxo, ';', require('demicolon.repeat_jump').next)
vim.keymap.set(nxo, ',', require('demicolon.repeat_jump').prev)
```

</details>

## Credit

[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) is used at the core of Demicolon's repeat logic. Credit to them for making an awesome plugin!
