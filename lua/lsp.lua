-- Setup Mason for managing external tools like LSP servers
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

-- Automatically install and configure LSP servers
require("mason-lspconfig").setup({
    ensure_installed = { "basedpyright", "lua_ls", "rust_analyzer", "jdtls", "csharp_ls", "tinymist" },
})

local lspconfig = require("lspconfig")

-- Configure diagnostics
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Global diagnostic keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show diagnostics in float", unpack(opts) })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic", unpack(opts) })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic", unpack(opts) })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Add diagnostics to location list", unpack(opts) })

-- Function to set buffer-local LSP keymaps when LSP attaches
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local bufopts = function(desc)
        return { noremap = true, silent = true, buffer = bufnr, desc = desc }
    end

    -- LSP navigation and features
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts("Go to declaration"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts("Go to definition"))
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "double", max_width = 100 })
    end, bufopts("Show hover documentation"))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts("Go to implementation"))
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts("Show signature help"))

    -- Workspace management
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts("Add workspace folder"))
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts("Remove workspace folder"))
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts("List workspace folders"))

    -- LSP types, refactoring and actions
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts("Go to type definition"))

    -- set nice remap:
    local function buffer_local_rename()
        local word = vim.fn.expand("<cword>")

        -- Create a scratch buffer with minimal floating window
        local buf = vim.api.nvim_create_buf(false, true)
        local width = 30
        local opts = {
            relative = "cursor",
            row = 1,
            col = 0,
            width = width,
            height = 1,
            style = "minimal",
            border = "rounded",
        }

        local win = vim.api.nvim_open_win(buf, true, opts)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { word })
        vim.api.nvim_buf_add_highlight(buf, -1, "Visual", 0, 0, -1)
        vim.cmd("startinsert")

        -- When <CR> is pressed in insert mode, perform local rename
        vim.keymap.set("i", "<CR>", function()
            local new_name = vim.trim(vim.fn.getline("."))
            vim.api.nvim_win_close(win, true)

            if new_name ~= "" and new_name ~= word then
                -- Replace current word only in this buffer (case sensitive)
                vim.cmd(string.format("%%s/\\<%s\\>/%s/g", word, new_name))
            end
        end, { buffer = buf, nowait = true })
    end
    vim.keymap.set("n", "<leader>rn", buffer_local_rename, { desc = "Rename in buffer only" })

    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts("Code action"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts("Find references"))

    -- Formatting
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts("Format buffer asynchronously"))
    vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, bufopts("Format buffer synchronously"))

    -- Java-specific (nvim-jdtls) keymaps
    if client.name == "jdtls" then
        vim.keymap.set("n", "<leader>oi", function()
            require("jdtls").organize_imports()
        end, bufopts("Organize imports"))
        vim.keymap.set("n", "<leader>ev", function()
            require("jdtls").extract_variable()
        end, bufopts("Extract variable"))
        vim.keymap.set("v", "<leader>em", function()
            require("jdtls").extract_method(true)
        end, bufopts("Extract method"))
    end
end

-- List of non-Java LSP servers to configure automatically
local servers = { "basedpyright", "texlab", "lua_ls", "astro", "rust_analyzer", "csharp_ls", "tinymist" }

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
    })
end

-- Export for use in plugins like nvim-jdtls
return {
    on_attach = on_attach,
}
