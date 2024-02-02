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
        "towolf/vim-helm",
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
                "helm_ls",
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
                        settings = {
                            Lua = {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    -- Get the language server to recognize the `vim` global
                                    globals = { "vim" },
                                },
                                workspace = {
                                    -- Make the server aware of Neovim runtime files
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                -- Do not send telemetry data containing a randomized but unique identifier
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,
                ["helm_ls"] = function()
                    lspconfig.helm_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            ["helm-ls"] = {
                                yamlls = {
                                    path = "yaml-language-server",
                                },
                            },
                        },
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

        --@diagnostic disable-next-line: redundant-parameter
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
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                },
            }),
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
