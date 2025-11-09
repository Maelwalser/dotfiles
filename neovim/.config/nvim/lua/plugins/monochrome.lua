return {
  'kdheepak/monochrome.nvim',
  name = "monochrome",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.monochrome_style = "amplified"
    vim.cmd.colorscheme "monochrome"
  end
}
