require('nvim-treesitter.configs').setup {
    ensure_installed = { 'latex', 'bash', 'lua', 'python', 'javascript', 'typescript', 'rust', 'c' },
  
    sync_install = false,
  
    auto_install = true,
  
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
  }
