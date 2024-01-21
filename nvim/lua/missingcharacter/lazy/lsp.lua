return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
        local lspconfig = require("lspconfig")
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "bashls",
                "bicep",
                "cmake",
                "docker_compose_language_service",
                "eslint",
                "gopls",
                "html",
                "htmx",
                "jsonls",
                "kotlin_language_server",
                "lua_ls",
                "powershell_es",
                "pylsp",
                "ruby_ls",
                "rust_analyzer",
                "tailwindcss",
                "terraformls",
                "tflint",
                "tsserver",
                "yamlls",
            },
            handlers = {
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
                    })
                end,
                ["pylsp"] = function()
                    lspconfig.pylsp.setup({
                        capabilities = capabilities,
                        settings = {
                            pylsp = {
                                plugins = {
                                    -- formatter options
                                    black = { enabled = true },
                                    autopep8 = { enabled = false },
                                    yapf = { enabled = false },
                                    -- linter options
                                    pylint = { enabled = false, executable = "pylint" },
                                    pyflakes = { enabled = false },
                                    pycodestyle = { enabled = false },
                                    -- type checker
                                    pylsp_mypy = { enabled = true },
                                    -- auto-completion options
                                    jedi_completion = { fuzzy = true },
                                    -- import sorting
                                    pyls_isort = { enabled = true },
                                },
                            },
                        },
                        flags = {
                            debounce_text_changes = 200,
                        },
                    })
                end,
            },
        })

        -- Set up nvim-cmp.
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
            }, { { name = "buffer" } }),
        })
        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}