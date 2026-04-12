-- headless_debug.lua
local dap = require('dap')

-- Configurar el adaptador de Python (asumiendo que debugpy está instalado en el entorno)
dap.adapters.python = {
  type = 'executable',
  command = '/home/alejandro/Descargas/headless sample2/.env/bin/python3', -- ruta directa al ejecutable de tu entorno virtual
  args = { '-m', 'debugpy.adapter' },
}

-- Configurar el lanzamiento del archivo principal
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Lanzar main.py",
    program = "main.py",
  }
}

-- Abrir el archivo primero para que el buffer exista
vim.cmd('edit main.py')

-- Definir un punto de interrupción (Breakpoint) programáticamente
-- Por ejemplo, pausar en la línea 7 de main.py
dap.set_breakpoint(nil, nil, nil, 7, vim.api.nvim_get_current_buf())

-- Configurar listeners para registrar en log el comportamiento mientras se ejecuta Headless
dap.listeners.after.event_stopped['headless_logger'] = function(session, body)
  print("\n[Headless Debug] 🛑 El depurador se ha detenido.")
  print("[Headless Debug] Motivo:", body.reason)
  
  -- Para continuar automáticamente a pesar de no ver UI:
  print("[Headless Debug] ⏩ Continuando ejecución del thread " .. (body.threadId or "unknown") .. "...\n")
  
  -- Utilizamos session:request('continue') con el threadId exacto en lugar de dap.continue() 
  -- para evadir el prompt interactivo en modo headless:
  if body.threadId then
    session:request('continue', { threadId = body.threadId })
  else
    dap.continue()
  end
end

dap.listeners.after.event_exited['headless_logger'] = function(session, body)
  print("\n[Headless Debug] ✅ Ejecución completada. Saliendo de Neovim...")
  vim.cmd('qa!') -- Cierra Neovim automáticamente al terminar el debug
end

-- Lanzar la sesión de depuración en main.py (simulado desde el inicio)
print("[Headless Debug] 🚀 Iniciando sesión de depuración interactiva en Headless Mode...")
dap.run(dap.configurations.python[1])
