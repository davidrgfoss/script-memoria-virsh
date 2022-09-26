#!/bin/bash

var1=0
var2=0

function crear-ficheros {
virsh -c qemu:///system dommemstat --domain "$maquina" > temp
sed -i '$d' temp
rm -Rf temp2
touch temp2
}

function filtrado {
while read fich
do
	
	for x in $(echo "$fich" | sed 's/[^0-9]*//g')
	do
		if [ $x -gt 1024 ]
		then
			sed -i "s/$x/$(($x/1024))/g" ./temp
		fi
	done
done < temp

while read fich
do
	for x in "$fich"
	do
		if [ $(echo "$fich" | sed 's/[^0-9]*//g') -lt 1025 ]
		then
			var1="${x}KB"
			echo "$var1" >> temp2
		else
			var2="${x}MB"
			echo "$var2" >> temp2
		fi
	done
done < temp
}

function mostrar {
	clear
	echo -e "\e[31mInformación de la memoria en la maquina $maquina"
	echo -e "\e[32m"
	cat temp2
	rm -Rf temp temp2
	echo -e "\e[0m"
}

if [ "$#" -eq "0" ]
then
	clear
	echo "No se comprueba si es correcta y debe estar encendida."
	echo "Escribe el nombre de la maquina"
	read -e -p "=> " maquina
	crear-ficheros
	filtrado
	mostrar
else
	echo "No se permite pasar argumentos a este script"
fi

