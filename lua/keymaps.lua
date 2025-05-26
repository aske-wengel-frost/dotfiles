vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })

vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find word" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffer" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "find help" })
vim.keymap.set({ "n", "v" }, "<leader>/", "gc", { remap = true, silent = true, desc = "Comment line/lines" })
vim.keymap.set('n', '<leader>sk', '<cmd>Telescope keymaps<CR>', { desc = 'Search Keymaps' })
vim.keymap.set('n', 'å', "o<C-r>+<Esc>", { desc = 'Paste on line below from clipboard' })
