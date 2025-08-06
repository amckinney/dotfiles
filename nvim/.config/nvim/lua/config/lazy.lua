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
    keys = {
      { "<C-n>", ":NvimTreeToggle<CR>", desc = "Toggle file tree" },
    },
    config = function()
      require("nvim-tree").setup({
        -- Disable netrw completely
        disable_netrw = true,
        hijack_netrw = true,

        -- View settings
        view = {
          width = 30,
          side = "left",
        },

        -- Renderer settings for clean look
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = false,
          full_name = false,
          highlight_opened_files = "none",
          root_folder_label = ":~:s?$?/..?",
          indent_width = 2,
          indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = false,  -- Disable file icons
              folder = true,
              folder_arrow = true,
              git = false,
            },
            glyphs = {
              default = "",  -- No default file icon
              symlink = "",
              bookmark = "",
              folder = {
                arrow_closed = "+",  -- Simple ASCII characters
                arrow_open = "-",
                default = "[+]",     -- Closed folder
                open = "[-]",        -- Open folder
                empty = "[+]",       -- Empty closed folder
                empty_open = "[-]",  -- Empty open folder
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
          symlink_destination = true,
        },

        -- Hijack cursor
        hijack_cursor = false,
        update_cwd = true,

        -- Diagnostics
        diagnostics = {
          enable = false,
        },

        -- Filters
        filters = {
          dotfiles = false,
          custom = { "^%.git$", "%.pyc$" },
          exclude = {},
        },

        -- Actions
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = false,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },

        -- Git integration (minimal)
        git = {
          enable = false,
          ignore = true,
          show_on_dirs = false,
          timeout = 400,
        },

        -- Trash
        trash = {
          cmd = "trash",
          require_confirm = true,
        },

        -- Update settings
        update_focused_file = {
          enable = false,
          update_cwd = false,
          ignore_list = {},
        },

        -- System open
        system_open = {
          cmd = "",
          args = {},
        },

        -- Log
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
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

  -- Tokyonight colorscheme (reliable and beautiful)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, moon, night, day
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
        on_highlights = function(highlights, colors)
          -- Keep your custom highlights
          highlights.htmlBold = { fg = "#af0000", bold = true }
          highlights.htmlItalic = { fg = "#ff8700", italic = true }
        end,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
})
