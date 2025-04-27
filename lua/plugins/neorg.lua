return {
  "nvim-neorg/neorg",
  version = "*", -- Pin to the latest stable release
  lazy = false,  -- Load on startup
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Load all default modules
        ["core.concealer"] = {
          config = {
            icon_preset = "varied", -- Use varied icons
          },
        },
      },
    })
  end,
}
