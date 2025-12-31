return {
  "norcalli/nvim-colorizer.lua",
  event = "BufReadPre",
  config = function()
    require("colorizer").setup({
      "*", -- all filetypes
    }, {
      RGB = true,
      RRGGBB = true,
      RRGGBBAA = true,
      css = true,
      css_fn = true,
      hsl_fn = true,
      names = false,
      mode = "background",
    })
  end,
}
