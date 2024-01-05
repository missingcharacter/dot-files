return {
  "folke/zen-mode.nvim",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function ()
    local mcutils = require("missingcharacter.utils")
    vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").setup {
            window = {
                width = 90,
                options = { }
            },
        }
        require("zen-mode").toggle()
        vim.wo.wrap = false
        vim.wo.number = true
        vim.wo.rnu = true
        mcutils.ColorMyPencils()
    end)


    vim.keymap.set("n", "<leader>zZ", function()
        require("zen-mode").setup {
            window = {
                width = 80,
                options = { }
            },
        }
        require("zen-mode").toggle()
        vim.wo.wrap = false
        vim.wo.number = false
        vim.wo.rnu = false
        vim.opt.colorcolumn = "0"
        mcutils.ColorMyPencils()
    end)
  end
}
