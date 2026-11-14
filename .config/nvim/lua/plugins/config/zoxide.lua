-- Options for the zoxide picker live in telescope.lua
local t = require("telescope")
t.load_extension("zoxide")
vim.keymap.set("n", "<leader>fz", t.extensions.zoxide.list)
