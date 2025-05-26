local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "bluz71/vim-moonfly-colors",
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            },
            appearance = {
                nerd_font_variant = 'mono'
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "lua", "python", "javascript", "html", "css", "bash" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true
                }
            }
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    },
    { "ellisonleao/gruvbox.nvim",  priority = 1000, config = true, opts = ... },
    { "cpea2506/one_monokai.nvim", priority = 1000, config = true },
    {
      'mfussenegger/nvim-jdtls',
      ft = { 'java' },
      config = function()
        local jdtls = require('jdtls')
        local lsp = require('lsp')  -- pulls your on_attach function

        local home = os.getenv("HOME")
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

        local root_markers = { ".git", "pom.xml", "build.gradle", "mvnw", "gradlew" }
        local root_dir = require('jdtls.setup').find_root(root_markers)
        if not root_dir then
          print("JDTLS: Could not find project root.")
          return
        end

        local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin/jdtls"

        local config = {
          cmd = { jdtls_path, "-data", workspace_dir },
          root_dir = root_dir,
          on_attach = lsp.on_attach,
        }

        jdtls.start_or_attach(config)
      end,
    }
})
