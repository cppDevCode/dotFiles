#!/bin/bash

dispositivo="AIWA-T600D"
if [ "$1" == "c" ]; then
	echo "[  ] Obteniendo Mac del dispositivo $dispositivo..."
	macAddress=$(hcitool scan | grep -i "$dispositivo" | awk '{print $1}')
	echo "[OK] Mac Obtenida $macAddress"
	if [ -n "$macAddress" ]; then
		echo "Conectando dispositivo"
		emparejado=$(bluetoothctl info 41:42:FA:2B:14:D4 | grep Paired | awk '{print $2}')
		echo $emparejado
	        if [ "$emparejado" == "yes" ]; then
			bluetoothctl connect "$macAddress"
		else
			# Agrupamos los comandos en un subshell para enviarlos a la MISMA sesión de bluetoothctl
			# Los 'sleep' son clave para darle tiempo a la interfaz de reaccionar
			# Agrupamos los comandos en un subshell
			(
				echo "power on"
				sleep 1
				echo "agent on"
				sleep 1
				echo "default-agent"
				sleep 1
			
				# --- EL PASO MÁGICO ---
				# Encendemos el escáner interno para que bluetoothd "vea" la MAC
				echo "scan on"
				sleep 5  # Le damos 5 segundos para que detecte el AIWA
				echo "scan off"
				sleep 1
				# ----------------------
			
				echo "pair $macAddress"
				sleep 4
				echo "trust $macAddress"
				sleep 1
				echo "connect $macAddress"
				sleep 2
				echo "quit"
			) | bluetoothctl
		fi
		#bluetoothctl connect "$macAddress"
	else
		echo "ERROR 001: No se encontro dispositivo: $dispositivo"
	fi
elif [ "$1" == "d" ]; then
	echo "[  ] Obteniendo Mac del dispositivo $dispositivo..."
	macAddress=$(bluetoothctl devices Connected | grep -i "$dispositivo" | awk '{print $2}')
	echo "[OK] Mac Obtenida $macAddress"
	if [ -n "$macAddress" ]; then
		echo "Desconectando dispositivo"
		bluetoothctl disconnect "$macAddress"
	else
		echo "ERROR 001: No se encontro dispositivo: $dispositivo"
	fi
fi
