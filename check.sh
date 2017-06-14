#!/bin/bash
# Script que comprueba cada 5 minutos si el gateway por defecto ha cambiado
# para detectar un posible ARP-Poisoning. 
# Puedes quitar el sleep y añadir este script a crontab btw
gateway=$(ip route|grep default|cut -f 3 -d " ")
while true
	do
		if [ "$gateway" == "$(ip route|grep default|cut -f 3 -d ' ')" ]
		then
			notify-send "Alerta, posible ARP-Posioning"
		fi
		sleep 300
	done

