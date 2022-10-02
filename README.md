# escape.nvim

escape.nvim is a plugin, which will replace your visual selection with an escaped string like this:

```
Some "Random String" -> Some \"Random String\"
```

# Usage

```
vim.keymap.set("v", "<leader>e", require("escpape").escape, { noremap = true, silent = true })
```
