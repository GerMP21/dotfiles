local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Moved from C-h/C-t/C-o/C-p, which clashed with split navigation,
-- the jumplist and completion
for i = 1, 4 do
  vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end)
end
