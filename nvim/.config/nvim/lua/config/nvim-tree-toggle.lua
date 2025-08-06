-- lua/config/nvim-tree-toggle.lua - Custom NvimTree toggle function
local M = {}

function M.toggle()
  local api = require("nvim-tree.api")
  local view = require("nvim-tree.view")
  
  if view.is_visible() then
    api.tree.close()
  else
    local current_file = vim.fn.expand("%:p")
    if current_file ~= "" and vim.fn.isdirectory(current_file) == 0 then
      api.tree.find_file()
    else
      api.tree.open()
    end
  end
end

return M
