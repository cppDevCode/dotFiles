-- Archivo de configuracion basado en https://medium.com/@edominguez.se/so-i-switched-to-neovim-in-2025-163b85aa0935
-- Fecha de Creación: 03/04/2026
-- Version de prueba NVIM 0.12
-- Version 1.6
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
            require("neo-tree").setup({
                close_if_last_window = true,
                filesystem = {
                    filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    follow_current_file = {
                        enabled = true,
                    },
                },
            })
            vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true, desc = "Explorador de Archivos" })
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
    -- 3.9 AUTOPAIR
    {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true -- Esto ejecuta el setup básico automáticamente
    },

    -- 4. Autocompletado
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
            },
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            --local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require("cmp")
            local ls = require("luasnip") -- Requerimos LuaSnip
            local s = ls.snippet
            local f = ls.function_node
            local i = ls.insert_node
            require("luasnip.loaders.from_vscode").lazy_load()
            -- --- CONFIGURACION DE AUTOCOMPLETADOS DE BRACKETS ---
           -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
            -- ----------------------------------------------------
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
            -- Snippet: seccion.clase -> <seccion class="clase"></seccion>
            ls.add_snippets("html", {
                s({ trig = "([%w-]+)%.([%w-]+)", regTrig = true, wordTrig = false }, {
                    f(function(_, snip)
                        return string.format('<%s class="%s">', snip.captures[1], snip.captures[2])
                    end, {}),
                    i(1),
                    f(function(_, snip)
                        return string.format('</%s>', snip.captures[1])
                    end, {}),
                }),
            })
            cmp.setup({
                snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        elseif cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if require("luasnip").jumpable(-1) then
                            require("luasnip").jump(-1)
                        elseif cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
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
            ensure_installed = { "lua", "vim", "vimdoc", "query", "java", "python", "javascript", "typescript", "html", "css" },
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end
    },

    -- 6. Autotag
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            opts = {
                -- Esto habilita el autocierre y autorenombre de etiquetas
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = true,
            }
        }
    },

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
                    lualine_x = {
                        -- Componente de Spotify integrado
                        {
                            function()
                                local status = io.popen("playerctl -p spotify metadata --format '{{ artist }} - {{ title }}' 2>/dev/null"):read("*l")
                                return (status and status ~= "") and ("🎧  " .. status) or ""
                            end,
                            color = { fg = "#1DB954", gui = "bold" },
                        },
                        'filetype', 
                        {
                            function()
                                local clients = vim.lsp.get_clients()
                                if next(clients) == nil then return 'No LSP' end
                                local names = {}
                                for _, client in ipairs(clients) do table.insert(names, client.name) end
                                return table.concat(names, ' ')
                            end,
                            icon = ' ',
                        }
                    },
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

            -- Configuración adicional: Terminal flotante con Midnight Commander
            local Terminal = require('toggleterm.terminal').Terminal
            local mc_term = Terminal:new({
                cmd = "mc --skin=catppuccin",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "curved",
                    width = math.floor(vim.o.columns * 0.95),  -- 95% del ancho de la pantalla
                    height = math.floor(vim.o.lines * 0.90),   -- 90% del alto de la pantalla
                },
                -- Evitar que Nvim intercepte escapes dentro de mc
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
                end,
            })

            -- Mapeo para <Espacio> + f + m
            vim.keymap.set('n', '<leader>fm', function()
                mc_term:toggle()
            end, { silent = true, desc = "Explorador estilo Midnight Commander" })
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
    },

    -- 12. Debugger (DAP) y soporte Headless
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jbyuki/one-small-step-for-vimkind", -- Para debuggear Lua (incluye headless support)
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "python" },
                handlers = {},
            })
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()

            -- DAP para Lua
            dap.configurations.lua = {
                {
                    type = 'nlua',
                    request = 'attach',
                    name = "Attach to running Neovim instance",
                }
            }
            dap.adapters.nlua = function(callback, config)
                callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
            end

            -- Autoclose/open UI
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

            -- Keymaps de Debugger via consola/TUI
            vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = "DAP: Iniciar/Continuar" })
            vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "DAP: Step Over" })
            vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "DAP: Step Into" })
            vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = "DAP: Breakpoint" })
            
            -- Iniciar servidor debugger para Lua (ideal para conectarse desde otro Nvim headless)
            vim.keymap.set('n', '<leader>ds', function()
                require"osv".launch({port = 8086})
                print("Servidor DAP de Lua iniciado en puerto 8086")
            end, { desc = "DAP: Iniciar Servidor Lua" })
        end
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

--Spotify
-- 1. Función de búsqueda (Linux/DBus)
local function spotify_search()
    vim.ui.input({ prompt = 'Buscar en Spotify: ' }, function(input)
        if input and input ~= "" then
            -- Formateamos la búsqueda para la URI de Spotify
            local query = input:gsub(" ", "%%20")
            -- Comando DBus para abrir la búsqueda en el cliente de Spotify
            os.execute("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri string:'spotify:search:" .. query .. "'")
            vim.notify("Buscando: " .. input, "info", { title = "Spotify" })
        end
    end)
end

-- 2. Función de control básica
local function spotify_control(command)
    return function() os.execute("playerctl -p spotify " .. command) end
end

-- --- KEYMAPS ACTUALIZADOS ---
local map = vim.keymap.set

-- Control de reproducción
map("n", "<leader>sp", spotify_control("play-pause"), { desc = "Spotify: Play/Pause" })
map("n", "<leader>sn", spotify_control("next"), { desc = "Spotify: Siguiente" })
map("n", "<leader>sb", spotify_control("previous"), { desc = "Spotify: Anterior" })

-- Buscar canción (Leader + s + f de 'find')
map("n", "<leader>sf", spotify_search, { desc = "Spotify: Buscar canción" })

-- Info de canción actual
map("n", "<leader>st", function()
    local handle = io.popen("playerctl -p spotify metadata --format '{{ title }} - {{ artist }}' 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
        vim.notify("Sintonizando: " .. result, "info", { title = "Spotify" })
    else
        vim.notify("Spotify no está reproduciendo", "warn")
    end
end, { desc = "Spotify: Info canción" })
