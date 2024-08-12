# demicolon.nvim

In addition to repeating `t`/`T`/`f`/`F` motions, this plugin lets you repeat diagnostic jumps (e.g. `]d`/`[d`) and [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move) jumps (e.g. `]f`/`[f`) with the `;`/`,` keys.

https://github.com/user-attachments/assets/e847cf39-40bd-49cb-9989-34e921b3393a

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'mawkler/demicolon.nvim',
  -- keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[' }, -- Uncomment this to lazy load
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {}
}
```

## Usage

After pressing any of the keymaps below, demicolon.nvim lets you repeat them with `;` and `,`.

### Vertical motions (`t`/`T`/`f`/`F`)

See [`:help t`](https://neovim.io/doc/user/motion.html#t), [`:help T`](https://neovim.io/doc/user/motion.html#T), [`:help f`](https://neovim.io/doc/user/motion.html#f), and [`:help F`](https://neovim.io/doc/user/motion.html#F) respectively.

### Diagnostic motions

By default, demicolon.nvim will create the diagnostic motion keymaps below. See [Configuration](#Configuration) for info on how to disable default keymaps.

| Motion | Description                        |
| ------ | ---------------------------------- |
| `]d`   | Next diagnostic (any severity)     |
| `[d`   | Previous diagnostic (any severity) |
| `]e`   | Next error                         |
| `[e`   | Previous error                     |
| `]w`   | Next warning                       |
| `[w`   | Previous warning                   |
| `]i`   | Next information                   |
| `[i`   | Previous information               |
| `]h`   | Next hint                          |
| `[h`   | Previous hint                      |

### Treesitter text-object motions

demicolon.nvim lets you repeat any [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move) motion. For example: `]f` to "jump to next function", `]c` to "jump to next class", etc.

> [!NOTE]
> To use treesitter text-objects you need to [configure `textobjects.move` in nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move).

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
    -- Create `t`/`T`/`f`/`F` key mappings
    horizontal_motions = true,
    -- Create ]d/[d, etc. key mappings to jump to diganostics. See demicolon.keymaps.create_default_diagnostic_keymaps
    diagnostic_motions = true,
    -- Create `;` and `,` key mappings
    repeat_motions = true,
  },
}
```

### eyeliner.nvim integration

[eyeliner.nvim](https://github.com/jinh0/eyeliner.nvim) can highlight unique letters in words when you press `t`/`T`/`f`/`F`. Here's my recommended configuration for using eyeliner.nvim together with demicolon.nvim

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
        return require('demicolon.jump').horizontal_jump_repeatably(key)()
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

## Credit

The treesitter portion of this plugin is just a wrapper over [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects). Credit to them for making an awesome plugin!
