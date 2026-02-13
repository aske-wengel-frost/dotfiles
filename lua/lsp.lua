require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "jdtls",
        "jsonls",
        "csharp_ls",
        "tinymist",
        "basedpyright",
        "ts_ls"
    },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()


vim.diagnostic.config({
    virtual_text = false,
    signs = {},
    underline = false,
    update_in_insert = false,
    severity_sort = true,
})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    local function bmap(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            noremap = true,
            silent = true,
            desc = desc,
        })
    end

    bmap("n", "gD", vim.lsp.buf.declaration, "Declaration")
    bmap("n", "gd", vim.lsp.buf.definition, "Definition")
    bmap("n", "gi", vim.lsp.buf.implementation, "Implementation")
    bmap("n", "gr", vim.lsp.buf.references, "References")
    bmap("n", "<space>D", vim.lsp.buf.type_definition, "Type definition")

    bmap("n", "K", function()
        vim.lsp.buf.hover({ border = "double", max_width = 100 })
    end, "Hover")

    bmap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

    bmap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace")
    bmap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace")
    bmap("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List workspaces")

    -- Formatting (0.11)
    bmap("n", "<space>f", function()
        vim.lsp.buf.format({ bufnr = bufnr })
    end, "Format")

    bmap("n", "<leader>fm", function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
    end, "Format (sync)")

    bmap("n", "<space>ca", vim.lsp.buf.code_action, "Code action")

    -- Java
    if client.name == "jdtls" then
        bmap("n", "<leader>oi", function()
            require("jdtls").organize_imports()
        end, "Organize imports")

        bmap("n", "<leader>ev", function()
            require("jdtls").extract_variable()
        end, "Extract variable")

        bmap("v", "<leader>em", function()
            require("jdtls").extract_method(true)
        end, "Extract method")
    end
end

local default = {
    on_attach = on_attach,
    capabilities = capabilities,
}

vim.lsp.config("lua_ls", default)
vim.lsp.config("rust_analyzer", default)
vim.lsp.config("texlab", default)
vim.lsp.config("csharp_ls", default)
vim.lsp.config("tinymist", default)
vim.lsp.config("ts_ls", default)

vim.lsp.config("basedpyright", {
    on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.set(bufnr, false)
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "basic",
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "none",
                    reportUnusedVariable = "none",
                },
            },
        },
    },
})

return {
    on_attach = on_attach,
    capabilities = capabilities,
}
