# Documentación de Neovim (`lazy_init.lua`)

Este documento sirve como referencia oficial para la configuración de Neovim basada en `lazy.nvim` que se encuentra en `lazy_init.lua`. Contiene el detalle de la arquitectura subyacente, los plugins instalados y todos los atajos de teclado configurables para alcanzar la máxima productividad.

---

## 1. Fundamentos y Sistema de Paquetes

- **Gestor de Paquetes:** Utiliza `lazy.nvim`. Si el gestor no está instalado en el sistema, el script lo descarga automáticamente mediante `git clone` y lo configura en los directorios de Neovim de manera silenciosa.
- **Tecla Líder (`Leader Key`):** Está configurada globalmente como un espacio **`<Space>`** (por lo que todos los comandos `<leader>` empiezan presionando la barra espaciadora).

---

## 2. Plugins Instalados

El gestor `lazy` está configurado para cargar los siguientes conjuntos de herramientas:

### 2.1 Estética y Tema
- **Catppuccin (`catppuccin/nvim`)**: Es el tema oficial que unifica toda la experiencia visual empleando una paleta suave (pastel) para menor fatiga visual. Es el tema base al que se adaptan el resto de plugins.

### 2.2 Navegación de Archivos
- **Neo-tree (`nvim-neo-tree/neo-tree.nvim`)**: Un explorador de archivos en formato de árbol en el lateral. Se configuró para mostrar ocultos, rastrear automáticamente el archivo abierto y cerrarse solo si es la última ventana activa.
- **ToggleTerm / Midnight Commander**: Se creó una instancia terminal gigante (95% de la pantalla) atada a `mc` para una navegación clásica de terminal (doble panel). Corre con el tema especial de `catppuccin`.

### 2.3 Entorno de Lenguajes (LSP & Autocompletado)
- **Mason (`williamboman/mason.nvim`)**: Instalador portátil de servidores, linters y formateadores (LSP). El entorno asegura mediante `mason-lspconfig` que existan servidores de Lua, HTML, CSS, TypeScript/Javascript (ts_ls) y Python (pyright).
- **LSPConfig (`neovim/nvim-lspconfig`)**: Conecta el editor como un cliente nativo hacia esos servidores para obtener reportes de sintaxis correctos y diagnósticos.
- **Nvim CMP (`hrsh7th/nvim-cmp`)**: Motor principal de autocompletado inteligenté que recopila datos tanto del LSP, el buffer actual, como las carpetas de tu sistema (`cmp-path`).
  - **LuaSnip (`L3MON4D3/LuaSnip`)**: Administra fragmentos de texto (snippets) e incluye código personalizado como snippets del clásico "*Lorem ipsum*".
- **Autopairs (`windwp/nvim-autopairs`) y Autotag (`windwp/nvim-ts-autotag`)**: Pares de cierres automáticos para paréntesis, corchetes o etiquetas HTML en tiempo de escritura, todo sincronizado con el motor de autocompletado para cero fricción.

### 2.4 Editor, Texto y Código
- **Treesitter (`nvim-treesitter/nvim-treesitter`)**: Un parseador avanzado que "entiende" genuinamente el lenguaje. Otorga un coloreado sintáctico y de indentación increíble, garantizado para lenguajes como Python, Java, JS/TS, HTML, CSS, Lua y más.
- **Bufferline (`akinsho/bufferline.nvim`)**: Convierte los diferentes "buffers" que mantienes abiertos en tradicionales pestañas estilo navegador (en la posición superior) que incluyen los diagnósticos (marcas de errores).
- **Lualine (`nvim-lualine/lualine.nvim`)**: Barra de estado inferior con un módulo ultra-modificado que, aparte de la rama de git, archivo actual y formato, **inyecta la información de Spotify reproduciendo música internamente** leyendo la metadata del SO.
- **Auto-save (`Pocco81/auto-save.nvim`)**: Actúa de silenciador continuo y te libra de oprimir ":w", guardando el progreso cada vez que sales del modo inserción (esencial para usar servidores frontend visualizando cambios en tiempo real).

### 2.5 Depuración y Productividad Externa
- **Nvim DAP (`mfussenegger/nvim-dap`)**: Depurador nativo. Incluye soporte con UI gráfico (`nvim-dap-ui`) e integración con Python. Además instala *Osv*, permitiendo depurar incluso el propio lenguaje Lua o instancias de Nvim por headless sockets.
- **Peek (`toppair/peek.nvim`)**: Permite la visualización previa asincrónica para ficheros en Markdown en modo rápido utilizando el compilador Deno en un navegador embebido.
- **ToggleTerm Consola**: Para trabajar bash local usa atajos sin salir del editor compartiendo variables de ambiente.

---

## 3. Hoja de Atajos de Teclado (Cheatsheet)

### Edición de Código y Diagnósticos (LSP)
Se aplican sólo si hay un servidor activo en el fichero (ej: `.lua` o `.py`):
| Comando | Acción |
|---|---|
| `gd` | Ir a la definición de la clase/función. |
| `K` (Mayúscula) | Mostrar información y documentación al pasar el cursor encima (`hover`). |
| `<Espacio> c a` | Mostrar 'Code Actions' (Sugerencias/Fix rápidos del LSP). |
| `<Espacio> r n` | Renombrar variables/funciones a nivel masivo y sistemático a través de todo tu proyecto. |
| `<C-Espacio>` | Forzar desplegar menú interactivo del motor de autocompletado en el teclado. |
| `<Tab>` | Navegar entre selecciones del autocompletado. |

### Navegación y Vistas 
| Comando | Acción |
|---|---|
| `<Espacio> e` | Abre el Menú Lateral de Árbol de archivos (Neo-Tree). |
| `<Espacio> fm` | Abre gigantescamente Midnight Commander (`mc`). |
| `<Shift> h` | Va hacia la pestaña a tu izquierda en la barra de Bufferline. |
| `<Shift> l` | Va hacia la pestaña a tu derecha en la barra de Bufferline. |
| `<Espacio> x` | Cierra y destruye la pestaña/buffer que estás visualizando. |

### Control del Depurador (Debugger - DAP)
| Comando | Acción |
|---|---|
| `<F5>` | Inicia la depuración de una instancia o continúa a la próxima parada.|
| `<F10>` | Paso de ejecución por encima de una línea (Step Over).|
| `<F11>` | Paso de ejecución hacia los detalles de la función (Step Into).|
| `<Espacio> d b` | Togglea poner/quitar un Breakpoint en la línea. |
| `<Espacio> d s` | Lanza el servidor backend Debugger para depuración remota sobre puerto 8086. |

### Comandos de Terminal (ToggleTerm)
| Comando | Acción |
|---|---|
| `<Ctrl> t` | Abre / Cierra una terminal horizontal inferior (si abres en modo insertar, ya estas escribiendo). |
| `<Esc>` | Dentro del terminal, escapa al modo terminal, volviendo al modo "Normal" de Vim para moverte por su historial textualmente o salir de ella. |

### Integraciones Adicionales y Utilities
| Comando | Acción |
|---|---|
| `<Espacio> p` | Abre Live Server y previsualiza archivos web. *(Mata el puerto 3000 de existir para evitar errores y lanza un File Watcher ciego)*. |
| `:PeekOpen` | Escribe este comando si buscas abrir `peek.nvim` para previsualizar Markdown. |

### Control Multimedia: Spotify
Basado en integraciones DBUS y comandos `playerctl` exclusivos para sistemas Linux.

| Comando | Acción |
|---|---|
| `<Espacio> s p` | Reproducir o Pausar audio (Play/Pause). |
| `<Espacio> s n` | Reproducir siguiente archivo (Next track). |
| `<Espacio> s b` | Reproducir canción previa o regresar al inicio (Prev track). |
| `<Espacio> s t` | Invoca una notificación en burbuja dentro de Neovim con el `'Título - Artista'` reproduciéndose de fondo (Track Info). |
| `<Espacio> s f` | Llama una búsqueda ingresando nombres directamente para enviarse mediante URI al reproductor (Search). |

---

## 4. Dependencias Externas (Sistema Operativo)

Para que todos los plugins listados funcionen al 100% de sus capacidades, se configuran las dependencias a nivel de sistema operativo. A continuación se incluyen los comandos de preparación e instalación probados para sistemas basados en Debian (Ubuntu, Linux Mint, Debian).

### 4.1 Midnight Commander (y Skin Catppuccin)
Esencial para habilitar el atajo del explorador doble panel (`<Espacio> e f`).

**1. Instalación del paquete:**
```bash
sudo apt update
sudo apt install mc -y
```

**2. Instalación del parche estético Catppuccin:**
Es imprescindible para que el panel asimile los colores unificados del editor y no rompa la consistencia visual. Este script crea el directorio de configuración personalizado de *mc* si no existe y descarga el perfil correspondiente.
```bash
# Crear la ruta para la piel
mkdir -p ~/.local/share/mc/skins

# Bajar el archivo INI e inyectarlo en su nueva casa
curl -sO https://raw.githubusercontent.com/catppuccin/mc/main/catppuccin.ini
mv catppuccin.ini ~/.local/share/mc/skins/catppuccin.ini
```
*(Nota de configuración interna: ToggleTerm ya está preparado por dentro con el comando `mc --skin=catppuccin` para autodetectar la existencia de este archivo).*

### 4.2 Control de Spotify y DBUS (`playerctl`)
El plugin Lualine de la parte inferior y los atajos del editor que manipulan el reproductor remoto requieren gestores DBUS.

```bash
sudo apt install playerctl dbus -y
```

### 4.3 Bases de Compilación y Lenguajes (Node, Deno, Live Server)
El ecosistema completo de **Mason** para descargar instaladores (LSPs), así como la previsualización de Markdown y HTML requieren frameworks básicos construidos sobre Node y dependencias `C/C++`.

```bash
# Dependencias base para instalar casi cualquier servidor de código
sudo apt install build-essential gcc make python3 python3-pip nodejs npm -y

# Instalar Live-Server a nivel global para previsualizaciones web automáticas (<Espacio> p)
sudo npm install -g live-server

# Instalar Motor Deno (Requisito estricto del plugin peek.nvim para el Markdown)
curl -fsSL https://deno.land/x/install/install.sh | sh
```
*(Es probable que tras aplicar las dependencias necesites reiniciar Neovim y ejecutar `:Mason` para verificar que todo haya cargado saludablemente).*

