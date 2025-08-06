-- lua/config/lazy.lua - Bootstrap and setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with plugins defined inline
require("lazy").setup({
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        filters = {
          custom = { "^%.git$", "%.pyc$" },
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        git = {
          ignore = false,
        },
        renderer = {
          hidden_display = "all",
        },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
      })
    end,
  },

  -- Commenting plugin
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Colorschemes
  {
    "flazz/vim-colorschemes",
    lazy = false,
    priority = 1000,
  },
})
