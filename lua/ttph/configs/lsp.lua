local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.defaults = function()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "rust_analyzer",
            "ts_ls"
        },
        handlers = {
            function(server_name) -- default handler (optional)

                require("lspconfig")[server_name].setup {}
            end,

            ["lua_ls"] = function()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup {
                    capabilities = M.capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = {
                                    vim.fn.expand "$VIMRUNTIME/lua",
                                    vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                                    vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                                    vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                                    "${3rd}/luv/library",
                                },
                                maxPreload = 100000,
                                preloadFileSize = 10000,
                            },
                        },
                    },
                }
            end

        }
    })
end

return M
