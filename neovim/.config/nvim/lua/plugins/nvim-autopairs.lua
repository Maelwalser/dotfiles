return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = true,
  opts = {
    disable_filetype = { "TelescopePrompt", "vim" },
    check_ts = true,                      -- enable treesitter
    ts_config = {
      lua = { "string" },                 -- don't add pairs in lua string treesitter nodes
      javascript = { "template_string" }, -- don't add pairs in javascript template_string
    }
  }
  -- use opts = {} for passing setup options

  -- this is equivalent to setup({}) function
}
