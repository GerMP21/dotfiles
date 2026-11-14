local parsers = { "latex", "bash", "lua", "python", "javascript", "typescript", "rust", "c",
  "markdown", "markdown_inline", "vim", "vimdoc", "query" }

require("nvim-treesitter").install(parsers)

-- The main branch no longer enables highlighting by itself
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", {}),
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
