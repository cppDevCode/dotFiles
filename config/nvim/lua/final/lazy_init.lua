-- Archivo de configuracion basado en https://medium.com/@edominguez.se/so-i-switched-to-neovim-in-2025-163b85aa0935
-- Fecha de Creación: 03/04/2026
-- Version de prueba NVIM 0.12
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
    -- 1. Apariencia
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- 2. Navegador de Archivos
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        config = function()
            vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true })
        end
    },

    -- 3. LSP y Mason (Configuración compatible con Nvim 0.11+)
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", "cssls" },
            })

            --local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Configuración de servidores
            local servers = { "lua_ls", "pyright", "ts_ls", "html", "cssls" }
            for _, lsp in ipairs(servers) do
                -- Se cambia para soporte de nvim version 0.11+
                  vim.lsp.config(lsp, {
                    capabilities = capabilities,
                })
                  vim.lsp.enable(lsp)
              --  lspconfig[lsp].setup({
                  --  capabilities = capabilities,
                --})
            end

            -- Atajos de teclado LSP
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                end,
            })
        end
    },

    -- 4. Autocompletado
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            -- Carga los snippets estilo VS Code (incluyendo el !)
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item() else fallback() end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                })
            })
        end
    },

    -- 5. Treesitter
    {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "lua", "vim", "vimdoc", "query", "java", "python" },
        highlight = { enable = true },
        indent = { enable = true },
    },
    config = function(_, opts)
        require("nvim-treesitter").setup(opts)
    end
},

    -- 6. Autotag
    { "windwp/nvim-ts-autotag", opts = {} }
})

vim.cmd.colorscheme "catppuccin"
