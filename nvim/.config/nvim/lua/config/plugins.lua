require("lazy").setup({
  -- File explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Telescope (fuzzy finder)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Comments
  { "numToStr/Comment.nvim", opts = {}, lazy = false },

  -- Colorscheme
  { "flazz/vim-colorschemes", lazy = false, priority = 1000 },
})
