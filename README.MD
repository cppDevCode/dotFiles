# 🚀 dotFiles

<p align="center">
  <em>Mis archivos de configuración personalizables, scripts de automatización y herramientas para un entorno de desarrollo productivo y moderno en Linux.</em>
</p>

---

## 📖 Descripción General

Este repositorio alberga mis **dotfiles** y configuraciones esenciales para mantener un ecosistema de desarrollo optimizado, estético y consistente en cualquier distribución basada en Linux (testeado principalmente en Linux Mint 22.3). El núcleo de la configuración pivota en torno a **Neovim 0.12+**, empleando gestores modernos y asegurando una profunda integración con el sistema para maximizar la productividad.

## 🛠️ Stack Tecnológico & Prerrequisitos

Para la correcta ejecución e instalación de todas las dependencias y scripts, se requiere el siguiente stack de herramientas:

### 🧩 Core
- **Neovim** `0.12+` (Motor principal del entorno)
- **Python 3** (se requiere el paquete `python3-pip`)
- **Node.js & npm** (Gestor de dependencias)
- **Deno** (Runtime moderno para aplicaciones en TS/JS)

### 📦 Herramientas CLI & Sistema
- **Compilación C/C++:** `gcc`, `make`
- **Multimedia:** `ffmpeg`, `avifenc`, `playerctl`, `Spotify Oficial`
- **Búsqueda & Navegación:** `ripgrep`, `mc` (Midnight Commander)
- **DevTools & Parsers:** `tree-sitter-cli`, `lazyrocks`, `debugpy`
- **Previsualización Web:** `live-server` (Emula el Live Preview de VSCode)

---

## ⚡ Instalación Rápida de Dependencias

A continuación, los comandos recomendados para desplegar las dependencias requeridas en Debian/Ubuntu (o distros derivadas como Mint):

```bash
# Herramientas del sistema y de red
sudo apt update && sudo apt install -y playerctl tree-sitter-cli ripgrep mc gcc make

# Herramientas y complementos específicos
sudo apt install -y lazyrocks

# Utilitarios y Servidores Web (Vía NPM)
npm install -g live-server deno
```

> **📌 Nota:** Es importante asegurarse de contar con `Python 3` y `pip` correctamente inicializados.

---

## 💻 Entorno de Neovim

La configuración de Neovim está diseñada buscando la velocidad, el uso intensivo de atajos de teclado y un workflow altamente dinámico.

### ⌨️ Keybindings Principales

| Uso / Módulo | Atajo de Teclado | Descripción |
| :--- | :--- | :--- |
| **Explorador** | `<Space> + e` | Activar/Mostrar el árbol de navegación de archivos. |
| **Explorador** | `<Space> + f + m` | Abrir versión extendida del navegador de archivos. |
| **Buscar** | `<Space> + f` | Realizar búsquedas dentro del árbol de navegación. |
| **Archivos** | `a` | Crear un archivo nuevo en el árbol de navegación. |
| **Visibilidad**| `<Shift> + h` | Mostrar/Ocultar archivos ocultos en el explorador. |
| **Live Preview**| `<Space> + p` | Activar el Live Server Preview para desarrollo web. |
| **App MC** | `<Space> + e + f` | Lanzar Midnight Commander como explorador clásico. |

### 🎵 Integración con Spotify
Control directo de tu música desde Neovim usando `playerctl`:
- **Play / Pause:** `<Space> + s + p`
- **Siguiente Pista:** `<Space> + s + n`
- **Pista Anterior:** `<Space> + s + b`
- **Buscar Canción:** `<Space> + s + f`

---

## 📜 Scripts de Automatización Bash

En el directorio `/bin/` se incluyen varios scripts diseñados para eficientizar tareas rudimentarias y multimedia:

### 📡 `bt.sh` (Gestor de Bluetooth)
Gestiona la conexión y desconexión rápida de tu dispositivo de audio Bluetooth (por defecto, configurado para *"AIWA-T600D"*).
- **Conectar Dispositivo:**
  ```bash
  bt c
  ```
- **Desconectar Dispositivo:**
  ```bash
  bt d
  ```

### 🔄 Utilidades de Transcodificación y Red
- **`mp3ToOgg.sh`**: Transcodificador masivo de formato MP3 a OGG.
- **`mp4ToWebM.sh`**: Convierte videos MP4 a WEBM optimizado para la web.
- **`toAvif.sh`**: Convierte recursos de imagen al moderno y eficiente formato AVIF.
- **`serverHttp.sh`**: Levanta un servidor web local de manera instantánea.

---

## 📂 Arquitectura del Repositorio

La organización interna refleja la disposición de los archivos en `$HOME`, permitiendo una reinstalación directa o uso de un script de despliegue (`install.sh`).

```text
.
├── config/                # Configuraciones core (~/.config/)
│    └── nvim/             # Configuración principal de Neovim (En Lua)
├── bin/                   # Utilitarios y scripts del sistema (~/bin/)
│    ├── bt.sh
│    ├── mp3ToOgg.sh
│    ├── mp4ToWebM.sh 
│    ├── serverHttp.sh
│    └── toAvif.sh
├── bashrc                 # Entorno del shell, aliases y config (~/.bashrc)
├── fonts/                 # Tipografías recomendadas (Ej: JetBrains Mono Nerd Font)
├── local/                 # Modificaciones de estado locales (~/.local/)
├── docs/                  # Documentación complementaria y tutoriales
└── install.sh             # Script de despliegue y symlinking
```

---

<p align="center">
  <em>Diseñado y optimizado para desarrolladores de alto rendimiento.</em>
</p>
