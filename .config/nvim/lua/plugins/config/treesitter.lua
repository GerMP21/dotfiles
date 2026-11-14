-- Parser list is shared with full-install.sh, which sets g:bootstrap and
-- installs them itself (synchronously) instead
if not vim.g.bootstrap then
  require("nvim-treesitter").install(require("plugins.config.ts_parsers"))
end

-- The main branch no longer enables highlighting by itself
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", {}),
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
