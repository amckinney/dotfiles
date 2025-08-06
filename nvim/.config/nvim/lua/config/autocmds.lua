-- lua/config/autocmds.lua - General autocommands
local autocmd = vim.api.nvim_create_autocmd

-- Example: Add your general autocommands here
-- These are autocommands that don't depend on specific plugins

-- Disable yank highlighting
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    -- Do nothing or clear highlights
  end,
})
