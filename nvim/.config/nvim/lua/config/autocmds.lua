-- lua/config/autocmds.lua - General autocommands
local autocmd = vim.api.nvim_create_autocmd

-- Example: Add your general autocommands here
-- These are autocommands that don't depend on specific plugins

-- Example: Highlight yanked text
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
