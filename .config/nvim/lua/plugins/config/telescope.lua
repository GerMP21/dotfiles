local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  extensions = {
    zoxide = {
      prompt_title = "[ Zoxide List ]",
      list_command = "zoxide query -ls",
      mappings = {
        default = {
          action = function(selection) vim.cmd.edit(selection.path) end,
          after_action = function(selection)
            print("Directory changed to " .. selection.path)
          end,
        },
        ["<C-f>"] = {
          keepinsert = true,
          action = function(selection) builtin.find_files({ cwd = selection.path }) end,
        },
      },
    },
  },
})
-- fzf-native is a compiled C library (built with `make` on install). If the
-- build failed, keep Telescope working with its default sorter instead of
-- failing the whole config.
if not pcall(telescope.load_extension, "fzf") then
  vim.notify("telescope-fzf-native isn't built; run :Lazy build telescope-fzf-native.nvim",
    vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.git_files)
vim.keymap.set("n", "<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Search: ") })
end)
