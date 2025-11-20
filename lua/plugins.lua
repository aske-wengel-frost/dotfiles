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
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "enter",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "python",
                    "javascript",
                    "html",
                    "css",
                    "bash",
                    "markdown",
                    "markdown_inline",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
        config = function()
            local jdtls = require("jdtls")
            local lsp = require("lsp") -- pulls your on_attach function

            local home = os.getenv("HOME")
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

            local root_markers = { ".git", "pom.xml", "build.gradle", "mvnw", "gradlew" }
            local root_dir = require("jdtls.setup").find_root(root_markers)
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
    },

    --- Colorschemes
    -- { "rebelot/kanagawa.nvim" },
    { "ellisonleao/gruvbox.nvim", priority = 1000 },
    -- { "cpea2506/one_monokai.nvim", priority = 1000, config = true },
    -- {
    --     "rose-pine/neovim",
    --     name = "rose-pine",
    --     opts = {
    --         disable_italics = true,
    --     }
    -- },
    --
    -- filetree ish
    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },
    { "nvimdev/lspsaga.nvim",     branch = "main" },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = { --[[ things you want to change go here]]
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "sdu-secondbrain",
                    path = "~/Documents/sdu/sdu-secondbrain",
                },
            },
            ui = {
                enable = false,
            },
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "sdu-secondbrain",
                    path = "~/Documents/sdu/sdu-secondbrain",
                },
            },
            ui = {
                enable = false,
            },
        },
        {
            "Kicamon/markdown-table-mode.nvim",
            ft = { "markdown" },
            config = function()
                require("markdown-table-mode").setup({
                    filetype = { "*.md" },
                    options = {
                        insert = true,
                        insert_leave = true,
                        pad_separator_line = false, -- whether to pad the separator line (---) with spaces
                        alig_style = "default",
                    },
                })
            end,
        },
    },
})
