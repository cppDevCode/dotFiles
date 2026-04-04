# Archivos de Configuración
Este repositorio contiene mis archivos de configuración personalizables (dotfiles), scripts de automatización en Bash y los assets necesarios para mantener un entorno de desarrollo productivo, estético y consistente en diferentes distribuciones de Linux.


## Prerequisitos
* NVIM 0.12+
* FFMPEG
* AVIFENC
* PYTHON 3
* GCC
* MAKE

## IMPORTANTE
La configuración de Nvim fue probada con la version 0.12 corriendo en Linux Mint 22.3.


## NVIM

### Uso
* Habilitar arbol de navegacion de Archivos Espacio + e
* Mostrar Archivos Ocultos Shift + H

## bt.sh 

### Descripción
Permite la conección y desconeccion del dispositivo de Bluetooth, busca por el nombre "AIWA-T600D"

###Uso
Conección del dispositivo
```bash
bt c
```

Desconeccion del dispositivo
```bash
bt d
```


📂 Estructura del Proyecto
```text
.
├── config/                # Configuraciones de programas (~/.config)
│    └── nvim/               # Neovim (Lua config)
├── home/                   # Archivos que van directamente en $HOME
│   ├── bin/
│   │    ├─ bt.sh
│   │    ├─ mp3ToOgg.sh
│   │    ├─ mp4ToWebM.sh 
│   │    ├─ serverHttp.sh
│   │    └─ toAvif.sh
│   ├── bashrc             # Corresponde a ~/.bashrc
│   └── fonts/             # Tipografías (JetBrains Mono, Nerd Fonts)
└── install.sh              # Script de despliegue automatizado

```
