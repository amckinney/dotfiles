-- lua/config/plugins.lua - Plugin specifications with their configurations
return {
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<C-n>", "<cmd>lua require('config.nvim-tree-toggle').toggle()<cr>", desc = "Toggle NvimTree" },
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        filters = {
          custom = { "^\.git$", "\.pyc$" },
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

      -- Plugin-specific autocommands (run after plugin is loaded)
      local autocmd = vim.api.nvim_create_autocmd

      -- Auto-open NvimTree when opening a directory
      autocmd("VimEnter", {
        desc = "Open NvimTree when starting with directory",
        callback = function()
          local args = vim.fn.argv()
          if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
            require("nvim-tree.api").tree.open()
            vim.cmd("wincmd p")
            vim.cmd("enew")
          end
        end,
      })

      -- Auto-close NvimTree when it's the last window
      autocmd("BufEnter", {
        desc = "Close NvimTree when it's the last window",
        callback = function()
          if vim.fn.winnr("$") == 1 and vim.bo.filetype == "NvimTree" then
            vim.cmd("q")
          end
        end,
      })
    end,
  },

  -- Fuzzy finder (fzf replacement)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
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
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },

  -- Colorschemes (equivalent to vim-colorschemes)
  {
    "flazz/vim-colorschemes",
    lazy = false, -- Load immediately for colorscheme
    priority = 1000, -- High priority to load before other plugins
  },
}
