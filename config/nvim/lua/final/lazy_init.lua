-- Archivo de configuracion basado en https://medium.com/@edominguez.se/so-i-switched-to-neovim-in-2025-163b85aa0935
-- Fecha de Creación: 03/04/2026
-- Version de prueba NVIM 0.12
-- Version 1.4
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

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Configuración de servidores
            local servers = { "lua_ls", "pyright", "ts_ls", "html", "cssls" }
            for _, lsp in ipairs(servers) do
                vim.lsp.config(lsp, {
                    capabilities = capabilities,
                })
                vim.lsp.enable(lsp)
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
            local ls = require("luasnip") -- Requerimos LuaSnip
            require("luasnip.loaders.from_vscode").lazy_load()
            -- --- CONFIGURACIÓN DE LOREM IPSUM ---
            ls.add_snippets("all", {
                ls.snippet("lorem", {
                    ls.text_node({
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
                        "nisi ut aliquip ex ea commodo consequat."
                    }),
                }),
            })
            -- ------------------------------------
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
    { "windwp/nvim-ts-autotag", opts = {} },

    -- 7. BufferLine Tabs
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = true,
                }
            })
        end,
    },
    -- 8. Barra de Estado (Lualine)
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch'},
                    lualine_c = {{'filename', path = 1}}, -- path = 1 muestra ruta relativa
                    lualine_x = {'filetype', {
                        function()
                            local msg = 'No LSP'
                            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                            local clients = vim.lsp.get_active_clients()
                            if next(clients) == nil then return msg end
                            local lsp_names = {}
                            for _, client in ipairs(clients) do
                                table.insert(lsp_names, client.name)
                            end
                            return table.concat(lsp_names, ' ')
                        end,
                        icon = ' ',
                    }},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                }
            })
        end
    },
    -- 9. ToggleTerm (Consola integrada)
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = [[<C-t>]], -- Cambia esto a <C-t> si no tienes ñ
                hide_numbers = true,
                shade_terminals = true,
                direction = 'horizontal', -- Se abre abajo como en VS Code
                close_on_exit = true,
                shell = vim.o.shell,
            })
        end
    },
       -- 10. Auto-save para que Live Server detecte cambios al escribir
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup({
                enabled = true,
                execution_message = {
                    message = function() return ("Cambios guardados...") end,
                    dim = 0.18,
                    cleaning_interval = 1250,
                },
                trigger_events = {"InsertLeave", "TextChanged"}, -- Guarda al salir de modo insertar o cambiar texto
            })
        end,
    },
    -- 11. Navegador embebido para Live Preview
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                auto_load = true,         -- Carga contenido al abrir
                close_on_bdelete = true,  -- Cierra la ventana si cierras el buffer
                syntax = true,            -- Soporte de resaltado
                theme = 'dark',           -- Tema oscuro para coincidir con Catppuccin
                throttle_at = 200000,     -- Límite de tamaño de archivo
                throttle_time =  30       -- Tiempo de actualización en ms
            })
            -- Comando para abrir la previsualización
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    }
})

-- Configuraciones Generales y Colores
vim.cmd.colorscheme "catppuccin"


-- Keymaps para Bufferline
local map = vim.keymap.set
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer Anterior" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Siguiente Buffer" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Cerrar Buffer actual" })

-- Atajos rápidos para la terminal
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  map('t', '<esc>', [[<C-\><C-n>]], opts) -- Salir del modo escritura en terminal
  map('t', '<C-t>', [[<Cmd>toggleterm<CR>]], opts) -- Cerrarla estando dentro
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Función para abrir Live Preview en un split vertical
vim.keymap.set('n', '<leader>p', function()
    vim.cmd("write") -- Guarda cambios
    
    -- Limpiamos el puerto 3000 por si acaso quedó algo colgado
    vim.fn.jobstart("fuser -k 3000/tcp")
    vim.fn.jobstart("live-server --port=3000 --no-browser --watch=. --ignore='**/.*'")
    print("Servidor corriendo en el puerto 3000...")
end, { desc = "Live Preview Blindado" })
