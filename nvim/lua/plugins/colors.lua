local mcutils = require("missingcharacter.utils")
return {
  {
      "folke/tokyonight.nvim",
      config = function()
          require("tokyonight").setup({
              style = "storm",
              transparent = true,
              terminal_colors = true,
              styles = {
                  comments = { italic = false },
                  keywords = { italic = false },
                  sidebars = "dark",
                  floats = "dark",
              },
          })
      end
  },
  {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
          require("rose-pine").setup({
              disable_background = true,
          })

          vim.cmd("colorscheme rose-pine")
          mcutils.ColorMyPencils()
      end
  }
}
