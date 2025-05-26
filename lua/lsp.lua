-- Setup Mason for managing external tools like LSP servers
require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Automatically install and configure LSP servers
require('mason-lspconfig').setup({
    ensure_installed = { 'pylsp', 'lua_ls', 'rust_analyzer', 'jdtls' },
})

local lspconfig = require('lspconfig')

-- Global diagnostic keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Show diagnostics in float', unpack(opts) })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic', unpack(opts) })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic', unpack(opts) })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'Add diagnostics to location list', unpack(opts) })

-- Function to set buffer-local LSP keymaps when LSP attaches
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = function(desc)
        return { noremap = true, silent = true, buffer = bufnr, desc = desc }
    end

    -- LSP navigation and features
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts('Go to declaration'))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts('Go to definition'))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts('Show hover documentation'))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts('Go to implementation'))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts('Show signature help'))

    -- Workspace management
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts('Add workspace folder'))
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts('Remove workspace folder'))
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts('List workspace folders'))

    -- LSP types, refactoring and actions
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts('Go to type definition'))
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts('Rename symbol'))
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts('Code action'))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts('Find references'))

    -- Formatting
    vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format({ async = true })
    end, bufopts('Format buffer asynchronously'))
    vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, bufopts('Format buffer synchronously'))

    -- Java-specific (nvim-jdtls) keymaps
    if client.name == "jdtls" then
        vim.keymap.set('n', '<leader>oi', function() require('jdtls').organize_imports() end, bufopts('Organize imports'))
        vim.keymap.set('n', '<leader>ev', function() require('jdtls').extract_variable() end, bufopts('Extract variable'))
        vim.keymap.set('v', '<leader>em', function() require('jdtls').extract_method(true) end, bufopts('Extract method'))
    end
end

-- List of non-Java LSP servers to configure automatically
local servers = { 'pylsp', 'texlab', 'lua_ls', 'astro' }

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
    }
end

-- Export for use in plugins like nvim-jdtls
return {
    on_attach = on_attach
}

