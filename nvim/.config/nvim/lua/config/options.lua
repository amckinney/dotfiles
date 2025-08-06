-- lua/config/options.lua - All Neovim options
local opt = vim.opt
local g = vim.g

-- Leader key
g.mapleader = ","

-- General settings
opt.number = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.splitbelow = true
opt.splitright = true
opt.hlsearch = true
opt.incsearch = true
opt.updatetime = 100
opt.backspace = "indent,eol,start"
opt.regexpengine = 2

-- Whitespace display
opt.list = true
opt.listchars = "tab:» ,trail:·"

-- Appearance
opt.termguicolors = true
opt.background = "dark"

-- Search highlights
vim.cmd("hi Search ctermbg=LightYellow")
