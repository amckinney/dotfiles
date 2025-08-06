require("config.lazy")      -- Load lazy.nvim
require("config.plugins")   -- Load plugins

-- General settings
vim.g.mapleader = ","
vim.o.number = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.updatetime = 100

-- Whitespace display
vim.o.list = true
vim.o.listchars = "tab:» ,trail:·"

-- Colorscheme configuration
vim.opt.termguicolors = true
vim.cmd("set background=dark")
vim.cmd("colorscheme habamax")
vim.cmd("set hlsearch")

-- Custom highlight groups
vim.cmd("hi Search ctermbg=LightYellow")
vim.cmd("hi htmlBold gui=bold guifg=#af0000 ctermfg=124")
vim.cmd("hi htmlItalic gui=italic guifg=#ff8700 ctermfg=214")

-- NvimTree
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Commenting
require("Comment").setup()

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
