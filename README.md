# Gruvstone

A minimal Neovim colorscheme inspired by **Alabaster** and based on the **Gruvbox Light** palette.

Gruvstone highlights only a small set of semantic elements and keeps everything else quiet, using warm, low-contrast colors suitable for long coding sessions.

---

## Design

Gruvstone intentionally limits highlighting to a few reliable categories:

1. **Strings**
2. **Constants** (numbers, booleans, symbols)
3. **Comments**
4. **Global definitions**

Everything else uses the default text color.

### Principles

* No keyword highlighting (`if`, `else`, `function`, etc.)
* No bold or italic styles
* Subtle background tinting for highlighted elements (Alabaster BG style)
* Only highlights things the parser can identify reliably

The goal is readability, not decoration.

---

## Installation

Using a plugin manager:

```lua
-- example with lazy.nvim
{
  "yourname/gruvstone",
  priority = 1000,
}
```

Then enable it:

```vim
:colorscheme gruvstone
```

or in Lua:

```lua
vim.cmd.colorscheme("gruvstone")
```

---

## Variants

* Background-based semantic highlighting
* Gruvbox-derived palette

---

## Credits

* Color palette: **Gruvbox**
* Philosophy: **Alabaster** by Niki Tonsky

---

## License

[MIT](./LICENSE)

