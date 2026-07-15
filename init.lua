vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 8
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.colorcolumn = '80'

local servers = { "clangd", "lua_ls", "tinymist", "basedpyright", "ruby_lsp", "ts_ls", "jsonls" }
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/oskarnurm/koda.nvim"}
})

require("trouble").setup()
require("mason").setup({
	firewall = {
		enabled = true
	}
})

require("toggleterm").setup({
	open_mapping = [[<c-t>]],
	direction = "float"
})
require("oil").setup({

	columns = {
		"permissions",
		"icon",
	},
	view_options = {
		show_hidden = true
	}
})

require("blink.cmp").setup({
	fuzzy = { implementation = "lua" },
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" }
	}
})
require("telescope").setup()
require("mini.pairs").setup()
require("mini.surround").setup()

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

vim.cmd.colorscheme("koda")

-- vim.opt.runtimepath:append("~/Developer/personal/plugins/negotium")
-- require("negotium").setup({ keymap = "<leader>jj" })

-- Pluginbindings
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format)
vim.keymap.set("n", "<C-n>", ":Oil<CR>")
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>fk", require("telescope.builtin").keymaps)
vim.keymap.set("v", "<leader>cc", '"+y')
-- vim.keymap.set("v", "<leader>rr", vim.lsp.buf.rename)

-- Magic
vim.keymap.set({ "v", "n" }, "<leader>/", ":norm gcc<CR>")
vim.keymap.set("n", "<leader>q", ":Trouble diagnostics toggle<CR>")
vim.keymap.set("n", "<ESC>", ":noh<CR>")

vim.keymap.set("v", "<Tab>", ":><CR>gv=gv")
vim.keymap.set("v", "<S-Tab>", ":<<CR>gv=gv")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
