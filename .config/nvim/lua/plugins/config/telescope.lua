local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({})
telescope.load_extension("fzf")

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.git_files)
vim.keymap.set("n", "<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Search: ") })
end)
