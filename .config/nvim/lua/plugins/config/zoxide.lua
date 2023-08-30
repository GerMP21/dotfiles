local t = require("telescope")
local z_utils = require("telescope._extensions.zoxide.utils")

t.setup({
    extensions = {
        zoxide = {
            prompt_title = "[ Zoxide List ]",
        
            list_command = "zoxide query -ls",
            mappings = {
                default = {
                    action = function(selection)
                        vim.cmd.edit(selection.path)
                    end,
                    after_action = function(selection)
                        print("Directory changed to " .. selection.path)
                    end
                },
                ["<C-b>"] = {
                    keepinsert = true,
                    action = function(selection)
                        builtin.file_browser({ cwd = selection.path })
                    end
                },
                ["<C-f>"] = {
                    keepinsert = true,
                    action = function(selection)
                        builtin.find_files({ cwd = selection.path })
                    end
                }
            }
        }
    }
})

t.load_extension('zoxide')

vim.keymap.set("n", "<leader>cd", t.extensions.zoxide.list)