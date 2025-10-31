-- Text objects for treesitter (parentheses, quotes, etc)
return
{
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",   -- Load after most things
}
