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
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = true,  -- Show inline diagnostic text
        signs = true,         -- Show diagnostic signs in gutter
        underline = true,     -- Underline diagnostic text
        update_in_insert = false, -- Don't update diagnostics in insert mode
        severity_sort = true, -- Sort by severity
        float = {
          border = 'rounded',
          source = 'always',  -- Show source (e.g., "basedpyright", "ruff")
          header = '',
          prefix = '',
        },
      })

      -- Filter out all ruff diagnostics
      local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == "ruff" then
          -- Don't show any diagnostics from ruff
          return
        end
        -- Show diagnostics from other clients (e.g. basedpyright)
        return original_handler(err, result, ctx, config)
      end

      -- Enable hover diagnostics on cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          }
          vim.diagnostic.open_float(nil, opts)
        end
      })

      -- Set updatetime for faster hover (default is 4000ms)
      vim.opt.updatetime = 1000

      require("mason").setup()

      -- Auto-install and setup LSP servers
      require("mason-lspconfig").setup({
        ensure_installed = {
          "basedpyright",
          "ruff",
        },
        automatic_installation = true,
      })

      -- Set up keybindings when any LSP attaches
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- Custom go-to-definition that auto-jumps to single results
          vim.keymap.set('n', 'gd', function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
              if err then
                vim.notify('Error: ' .. err.message, vim.log.levels.ERROR)
                return
              end

              if not result or vim.tbl_isempty(result) then
                vim.notify('No definition found', vim.log.levels.WARN)
                return
              end

              -- If single result, jump directly
              if #result == 1 then
                vim.lsp.util.jump_to_location(result[1], 'utf-8')
              else
                -- Multiple results, use the default picker
                vim.lsp.util.jump_to_location(result, 'utf-8')
              end
            end)
          end, opts)

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          
          -- Manual diagnostic keybindings
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          
          -- Disable ruff's overlapping capabilities
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.completionProvider = false
          end
        end,
      })
    end
  },

  -- Autocompletion with blink.cmp
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    build = "cargo build --release",
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "default",
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide" },
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = { "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-u>"] = { "scroll_documentation_up", "fallback" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        },

        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono"
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              score_offset = 90,
            },
            path = {
              name = "Path",
              module = "blink.cmp.sources.path",
              score_offset = 3,
            },
            snippets = {
              name = "Snippets",
              module = "blink.cmp.sources.snippets",
              score_offset = 85,
            },
            buffer = {
              name = "Buffer",
              module = "blink.cmp.sources.buffer",
              score_offset = 5,
            },
          }
        },

        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            draw = {
              treesitter = { "lsp" }
            }
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
          ghost_text = {
            enabled = vim.g.ai_cmp_enabled or false,
          },
        },

        signature = {
          enabled = true
        }
      })
    end,
  },

  -- Python-specific features
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python"
    },
    config = function()
      require("venv-selector").setup({
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },

  -- Testing support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            python = ".venv/bin/python",
          }),
        },
      })
    end,
    keys = {
      { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
      { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run file tests" },
      { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle test summary" },
    },
  },

  -- Debugging support
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("dap-python").setup("python") -- or specify path to python with debugpy

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
      { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step over" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step into" },
    },
  },

  -- Formatting and linting
  {
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_organize_imports", "ruff_format" }
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
    keys = {
      { "<leader>f", "<cmd>lua require('conform').format()<cr>", desc = "Format buffer" },
    },
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "vim", "vimdoc" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

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
          -- Exit terminal mode in order to yank text
          vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
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

      -- Handle mouse clicks in terminal - always go to end of line and enter insert mode
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "term://*",
        callback = function()
          -- Set up a buffer-local mapping for mouse clicks
          vim.keymap.set('n', '<LeftMouse>', function()
            vim.cmd('normal! G$')  -- Go to last line, end of line
            vim.cmd('startinsert') -- Enter insert mode
          end, { buffer = 0, desc = 'Terminal mouse click handler' })
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
