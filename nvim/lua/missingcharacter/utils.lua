local M = {}

function M.ColorMyPencils(color)
  color = color or "noctis"
  vim.cmd.colorscheme(color)
end


return M
