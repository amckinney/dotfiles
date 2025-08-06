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
              file = true,
              folder = true,
              folder_arrow = true,
              git = false,
            },
            glyphs = {
              default = "",  -- No default file icon
              symlink = "",
              bookmark = "",
              folder = {
                arrow_closed = "▶",
                arrow_open = "▼",
                default = "📁",
                open = "📂",
                empty = "📁",
                empty_open = "📂",
                symlink = "📁",
                symlink_open = "📂",
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

  -- Terminal toggle
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-t>]], 
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        -- Hide the terminal buffer name
        winbar = {
          enabled = false,
        },
        -- Custom terminal window navigation
        on_create = function(term)
          local opts = {buffer = term.bufnr}
          vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
          vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
          vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
          vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
          -- Make : exit terminal mode and enter command mode
          vim.keymap.set('t', ':', [[<C-\><C-n>:]], opts)
          -- Toggle nvim-tree from terminal mode (assuming you use <leader>e)
          vim.keymap.set('t', '<C-n>', [[<C-\><C-n><cmd>NvimTreeToggle<CR>]], opts)
        end,
      })

      -- Auto-open terminal only when opening nvim without arguments
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only open terminal if no files were specified
          if #vim.fn.argv() == 0 then
            vim.defer_fn(function()
              require("toggleterm").toggle()
              -- Focus back to the main window and ensure normal mode
              vim.cmd("wincmd k")
              vim.cmd("stopinsert") -- Ensure we're in normal mode
            end, 100)
          end
        end,
      })

      -- Properly handle entering insert mode in terminal
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "term://*",
        callback = function()
          vim.defer_fn(function()
            if vim.api.nvim_buf_get_option(0, 'buftype') == 'terminal' then
              vim.cmd('normal! G') -- Go to last line
              vim.cmd('startinsert') -- Enter insert mode at cursor position
            end
          end, 50)
        end,
      })

      -- Make sure navigation works in normal mode too
      vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
      vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
      vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
      vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
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
          file_ignore_patterns = { 
            "node_modules/.*", 
            "%.git/.*",
            "%.DS_Store"
          },
          -- Make sure it searches from project root
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        pickers = {
          find_files = {
            -- Show hidden files but ignore .git
            hidden = true,
            -- Search from project root, not just current directory
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          }
        }
      })

      -- Add keymappings
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-r>', builtin.find_files, { desc = 'Find files' })
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
