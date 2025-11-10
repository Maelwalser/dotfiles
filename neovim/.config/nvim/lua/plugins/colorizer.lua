return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      user_default_options = {
        RGB = true, -- #000000
        HSL = true, -- #000000
      },
      -- Rule for CSS.
      css = {
        css_variables = true,
      },
    })
  end,
}
