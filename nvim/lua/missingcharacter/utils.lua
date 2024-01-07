local M = {}

function M.ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)
end


return M
