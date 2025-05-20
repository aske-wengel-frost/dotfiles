vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })

vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find word" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffer" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "find help" })
vim.keymap.set({ "n", "v" }, "<leader>/", "gc", { remap = true, silent = true, desc = "Comment line/lines" })
vim.keymap.set('n', '<leader>sk', '<cmd>Telescope keymaps<CR>', { desc = 'Search Keymaps' })
