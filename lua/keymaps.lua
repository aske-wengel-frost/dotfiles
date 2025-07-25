vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })

vim.keymap.set('n', '<C-n>', '<cmd>Oil<CR>', { desc = "Open parent directory using oil." })
-- vim.keymap.set('n', '<C-n>', function() require('oil').toggle_float() end, {desc = "Toggle oil"}) -- if you want floating window instead.
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })

--ToggleTerm
vim.keymap.set('n', '<C-t>', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })
vim.keymap.set('t', '<C-t>', [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = 'Toggle Terminal from Terminal' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Init visual-mode inside Toggle Terminal' })
vim.keymap.set('t', '<C-+>', [[<C-\><C-n>:resize +2<CR>i]], { desc = 'Increase terminal height' })
vim.keymap.set('t', '<C-->', [[<C-\><C-n>:resize -2<CR>i]], { desc = 'Decrease terminal height' })
vim.keymap.set('t', '<C-0>', [[<C-\><C-n>:resize 12<CR>i]], { desc = 'Set terminal to default height' })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })

-- Customm telescope keybinding for finding config files.
vim.keymap.set('n', '<leader>fc', function()
    require('telescope.builtin').find_files({
        prompt_title = 'Find Config Files',
        cwd = vim.fn.expand("~/.config"),
        hidden = true,
        follow = true,
        no_ignore = true,
        find_command = {
            'fd', '--type', 'f', '--hidden', '--follow', '--exclude', '.git'
        }
    })
end, { desc = "Find in ~/.config" })

vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find word" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffer" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "find help" })
vim.keymap.set({ "n", "v" }, "<leader>/", "gc", { remap = true, silent = true, desc = "Comment line/lines" })
vim.keymap.set('n', '<leader>sk', '<cmd>Telescope keymaps<CR>', { desc = 'Search Keymaps' })
vim.keymap.set('n', 'å', "o<C-r>+<Esc>", { desc = 'Paste on line below from clipboard' })
vim.keymap.set('x', '<leader>cc', '"+y', { desc = "Copy selected to clipboard (y+)" })
vim.keymap.set('n', '<Esc>', "<cmd>noh<CR>", { desc = 'Unhighlight search.' })
