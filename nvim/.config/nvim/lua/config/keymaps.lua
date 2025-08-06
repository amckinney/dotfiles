-- lua/config/keymaps.lua - All key mappings
local keymap = vim.keymap.set

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { noremap = true, desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { noremap = true, desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, desc = "Move to right window" })

-- Tab indentation in visual mode
keymap("v", "<Tab>", ">gv", { noremap = true, desc = "Indent selection" })
keymap("v", "<S-Tab>", "<gv", { noremap = true, desc = "Unindent selection" })

-- Custom escape and completion mappings
keymap("i", "jj", "<Esc>", { noremap = true, desc = "Quick escape" })
keymap("i", "kk", "<C-x><C-o>", { noremap = true, desc = "Omni completion" })

-- System clipboard operations with leader key
keymap("n", "<leader>y", '"+y', { noremap = true, desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", '"+yg_', { noremap = true, desc = "Yank line to system clipboard" })
keymap("v", "<leader>y", '"+y', { noremap = true, desc = "Yank selection to system clipboard" })

keymap("n", "<leader>p", '"+p', { noremap = true, desc = "Paste from system clipboard" })
keymap("n", "<leader>P", '"+P', { noremap = true, desc = "Paste before from system clipboard" })
keymap("v", "<leader>p", '"+p', { noremap = true, desc = "Paste from system clipboard" })
keymap("v", "<leader>P", '"+P', { noremap = true, desc = "Paste before from system clipboard" })

-- Telescope key mappings (will be available after plugin loads)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, desc = "Help tags" })
