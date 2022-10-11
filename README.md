# escape.nvim

escape.nvim is a plugin, which will replace your visual selection with an escaped string.

## Usage

Setup a visual mode binding to any of the functions available

```lua
vim.keymap.set("v", "<leader>e", require("escape").escape, { noremap = true, silent = true })
```

## Available functions

For more detail see `:help escape-nvim-functions`

* escape

```
Some "Random String" -> Some \"Random String\"
```

* encode\_uri\_component

```
query string with a / -> query%20string%20with%20a%20%2F
```

or apply a custom converter with `apply_converter`
