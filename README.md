# escape.nvim

escape.nvim is a plugin, which will replace any text in your buffer with an escaped string.

It can be used with visual mode and motions such as `iw`.

## Usage

Setup a binding to any of the functions available

```lua
vim.keymap.set({"n", "v"}, "<leader>e", require("escape").escape, { noremap = true, silent = true })
```

You can then use it in visual mode, or with a motion (e.g. `<leader>eiw`)

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
